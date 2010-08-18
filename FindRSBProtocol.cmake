# Find the RSB Protocol Buffer files
# 
# defines:
# RSBPROTO_ROOT, root of the protofiles
# RSBPROTO_FILES, list of fully quallyfied names 
#
# Copyright (C) 2010 by Johannes Wienke <jwienke at techfak dot uni-bielefeld dot de>
#
# This program is free software; you can redistribute it
# and/or modify it under the terms of the GNU General
# Public License as published by the Free Software Foundation;
# either version 2, or (at your option)
# any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#

INCLUDE(FindPackageHandleStandardArgs)

FIND_FILE(RSBPROTO_ROOT
          NAMES Notification.proo
          PATH_SUFFIX "rsbprotocol"
          PATHS "${CMAKE_INSTALL_PREFIX}/share/")
         
FILE(GLOB_RECURSE RSBPROTO_FILES "${RSBPROTO_ROOT}/*.proto")

FIND_PACKAGE_HANDLE_STANDARD_ARGS(RSBProtocol DEFAULT_MSG RSBPROTO_ROOT RSBPROTO_FILES)

MARK_AS_ADVANCED(RSBPROTO_ROOT RSBPROTO_FILES)
