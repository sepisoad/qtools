local log = require('libs.lua.log.log')
local xio = require('libs.lua.utils.io')
local qoi = require('libs.lua.image.qoi')
local bits = require('libs.lua.utils.bits')
local paths = require('libs.lua.utils.paths')
local sqt = require('src.common')

require('libs.lua.app.types')

local read = bits.reader
local write = bits.writer

--- -----------------------------------------------
---@param tex_header TexHeader
---@param palette_data PaletteData
---@return any
local function convert_tex_to_qoi (tex_file_path, palette_file_path, tex_header, palette_data)
  log.dbg("converting tex image to qoi")

  local qoi_data = nil
  local err = nil
  qoi_data, err = qoi.encode_indexed(tex_header.Data, palette_data, tex_header.Width, tex_header.Height)
  if err then
    log.fatal(string.format("failed to decode '%s' using '%s' to qoi", tex_file_path, palette_file_path), err)
  end

  return qoi_data
end

--- -----------------------------------------------
---@param qoi_data any
---@param palette_data any
---@param qoi_path string
---@param tex_name string|nil
---@return TexHeader
local function convert_qoi_to_tex(qoi_data, palette_data, qoi_path, tex_name)
  log.dbg("converting qoi image to tex")

  local tex_data, tex_width, tex_height = qoi.decode_indexed(qoi_data, palette_data)
  if not tex_data then
    log.fatal(string.format("failed to convert qoi data to tex data from '%s'", qoi_path))
  end

  if tex_name == nil then
    tex_name, _ = paths.file_name(qoi_path)
  end

  ---@type TexHeader
  local tex_header = {
    Name = tex_name,
    Width = tex_width,
    Height = tex_height,
    Data = tex_data
  }

  return tex_header
end

--- -----------------------------------------------
---@param tex_header TexHeader
---@param tex_file_path string
local function save_tex_file (tex_header, tex_file_path)
  log.dbg(string.format("saving LMP data into %s", tex_file_path))

  local tex_f <close> = xio.open(tex_file_path, "wb")
  tex_f:write(string.pack("=i", tex_header.Width))
  tex_f:write(string.pack("=i", tex_header.Height))
  tex_f:write(tex_header.Data)
end

--- -----------------------------------------------
---@param file_path string
local function create_toplevel_dir_for_output_file (file_path)
  log.dbg(string.format("creating top level directory for path '%s'", file_path))

  local _, err = paths.create_dir_for_file_path(file_path)
  if err ~= nil then
    log.fatal(string.format("failed to create top level directory for file '%s'", file_path))
  end
end

--- -----------------------------------------------
---@param path string
---@return TexHeader
local function load_tex_data_from_file (path)
  log.dbg("loading .TEX file header")

  local tex_f <close> = xio.open(path, "rb")

  ---@type TexHeader
  local header = {
    Name = read.cstring(tex_f, TexHeader._Name),
    Width = read.integer(tex_f),
    Height = read.integer(tex_f),
    Data = read.all(tex_f)
  }

  if header.Name == nil or
     header.Name == "" or
     header.Width <= 0 or
     header.Height <= 0 or
     header.Data == nil then
    log.fatal("the '" .. path .. "' file is not valid")
  end

  return header
end

--- -----------------------------------------------
---@param tex_file_path string
---@param tex_header TexHeader
local function print_tex_info (tex_file_path, tex_header)
  log.dbg("printing .TEX file information")

  local disk_size = paths.get_file_disk_size(tex_file_path)

  print("--- Information ------------------------------------------")
  print(string.format("  ◉ Path:               %s", tex_file_path))
  print(string.format("  ◉ Name:               %s", tex_header.Name))
  print(string.format("  ◉ Width:              %d pixels", tex_header.Width))
  print(string.format("  ◉ Height:             %d pixels", tex_header.Height))
  print(string.format("  ◉ Image Data size:    %d bytes", #tex_header.Data))
  print(string.format("  ◉ Image Size on disk: %d bytes", disk_size))
end

--- ===============================================
--- info command
--- ===============================================
---@param tex_file_path string
local function cmd_info (tex_file_path)
  local tex_header = load_tex_data_from_file(tex_file_path)
  print_tex_info(tex_file_path, tex_header)
end

--- ===============================================
--- decode command
--- ===============================================
---@param tex_file_path string
---@param palette_file_path string
---@param qoi_file_path string
local function cmd_decode (tex_file_path, palette_file_path, qoi_file_path)
  local tex_header = load_tex_data_from_file(tex_file_path)
  local palette_data = sqt.load_palette_data_from_file(palette_file_path)
  local qoi_data = convert_tex_to_qoi(tex_file_path, palette_file_path, tex_header, palette_data)
  create_toplevel_dir_for_output_file(qoi_file_path)
  sqt.save_qoi_file(qoi_data, qoi_file_path)
end

--- ===============================================
--- encode command
--- ===============================================
---@param tex_file_path string
---@param palette_file_path string
---@param qoi_file_path string
local function cmd_encode (qoi_file_path, palette_file_path, tex_file_path)
  local palette_data = sqt.load_palette_data_from_file(palette_file_path)
  local qoi_data = sqt.load_qoi_data(qoi_file_path)
  local tex_header = convert_qoi_to_tex(qoi_data, palette_data, qoi_file_path)
  create_toplevel_dir_for_output_file(tex_file_path)
  save_tex_file(tex_header, tex_file_path)
end

--- ===============================================
--- Module
--- ===============================================
return {
  info = cmd_info,
  decode = cmd_decode,
  encode = cmd_encode,
}
