# SEPI'S QUAKE TOOLS (SQT)

![logo](docs/sqt.png)

SQT is a set of commands to work with quake 1 files.

The code is licensed under GNU general public license version 3 (GPLv3)

# How to build
The build commands need some refinement, but the code itself is easy to compile and fully portable. My priority is to get the code into the desired state first, after which I’ll update the Makefile to streamline the build process.

# How to use

SQT comes with a lot of sub commands to work with various quake files.

items marked as ✅ are already implemented.

items marked as ❌ are NOT implemented YET.


## to level commands
- `pak`: this command deals with the .PAK files
- `lmp`: this command deals with the .LMP files
- `wad`: this command deals with the .WAD files

## pak command
- ✅ `info`: this command deals with the .PAK files
- ✅ `list`: use this to list items in a .PAK file
- ✅ `extract`: use this to extract items in a .PAK file
- ✅ `create`: use this to create a .PAK file

## lmp command
- ✅ `info`: use this to get some details about a .LMP file
- ✅ `decode`: use this to decode a .LMP file into a .qoi image
- ✅ `encode`: use this to encode a .qoi image into a .LMP file

* ~this command automatically encodes a non-indexed PNG file into a lump file, converting its colors to the standard Quake palette using an approximation technique. No additional steps are required from the user, bellow is an example of the indexd version of the SQT qoi logo:~ this might not be true since dropping png in favour of qoi format

![logo](docs/sqt_idx.png)

## wad command
- ✅ `info`: use this to get some details about a .WAD file
- ✅ `list`: use this to list items in a .WAD file
- ✅ `extract`: use this to extract items in a .WAD file
- ❌ `create`: use this to create a .WAD file

## tex command
- ❌ `info`: use this to get some details about a .TEX file
- ❌ `decode`: use this to decode a .TEX file into a .qoi image
- ❌ `encode`: use this to encode a .qoi image into a .TEX file


## other file types to cover soon
- NAV
- BSP
- LIT
- MDL
- MD5ANIM
- MD5MESH
- BNVIB
- DEM
- BIN
- DAT

# Credtis:
SQT relies on the following tools and open-source projects.

- [miniz](https://github.com/richgel999/miniz)
- [lua](https://www.lua.org/)
- [lua files ystem](http://lunarmodules.github.io/luafilesystem)
- [lua argparse](https://github.com/mpeterv/argparse)
- [lua minifs](https://github.com/tst2005/lua-minifs/)
- [lua strease](https://github.com/krai-me/strease)
- [lua pretty print](https://github.com/jagt/pprint.lua)

# Notes:
- [x] maybe replace png with qoi: https://github.com/phoboslab/qoi
- [ ] consider using this: https://github.com/KaisenAmin/c_std
- [ ] post this on https://www.slipseer.com/
- [ ] post this on https://quakewiki.org