# Copyright 2020 Open Source Robotics Foundation, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

###################################################################################################
#
# CMake script for finding zenoh_pico
#
# Input variables:
#
# - zenoh_pico_ROOT_DIR (optional): When specified, header files and libraries will be searched for in
#     ${zenoh_pico_ROOT_DIR}/include
#     ${zenoh_pico_ROOT_DIR}/libs
#   respectively, and the default CMake search order will be ignored. When unspecified, the default
#   CMake search order is used.
#   This variable can be specified either as a CMake or environment variable. If both are set,
#   preference is given to the CMake variable.
#   Use this variable for finding packages installed in a nonstandard location, or for enforcing
#   that one of multiple package installations is picked up.
#
#
# Cache variables (not intended to be used in CMakeLists.txt files)
#
# - zenoh_pico_INCLUDE_DIR: Absolute path to package headers.
# - zenoh_pico_LIBRARY: Absolute path to library.
#
#
# Output variables:
#
# - zenoh_pico_FOUND: Boolean that indicates if the package was found
# - zenoh_pico_INCLUDE_DIRS: Paths to the necessary header files
# - zenoh_pico_LIBRARIES: Package libraries
#
#
# Example usage:
#
#  find_package(zenoh)
#  if(NOT zenoh_pico_FOUND)
#    # Error handling
#  endif()
#  ...
#  include_directories(${zenoh_pico_INCLUDE_DIRS} ...)
#  ...
#  target_link_libraries(my_target ${zenoh_pico_LIBRARIES})
#
###################################################################################################

# Get package location hint from environment variable (if any)
if(NOT zenoh_pico_ROOT_DIR AND DEFINED ENV{zenoh_pico_ROOT_DIR})
    set(zenoh_pico_ROOT_DIR "$ENV{zenoh_pico_ROOT_DIR}" CACHE PATH
        "zenoh base directory location (optional, used for nonstandard installation paths)")
endif()

if(zenoh_pico_ROOT_DIR)
  set(zenoh_pico_INCLUDE_PATH PATHS "${zenoh_pico_ROOT_DIR}/include" NO_DEFAULT_PATH)
  set(zenoh_pico_LIBRARY_PATH PATHS "${zenoh_pico_ROOT_DIR}/lib" NO_DEFAULT_PATH)
else()
  set(zenoh_pico_INCLUDE_PATH "")
  set(zenoh_pico_LIBRARY_PATH "")
endif()

# Search for headers and the library
find_path(zenoh_pico_INCLUDE_DIR NAMES "zenoh.h" ${zenoh_pico_INCLUDE_PATH})
find_library(zenoh_pico_LIBRARY NAMES zenohc ${zenoh_pico_LIBRARY_PATH})

mark_as_advanced(zenoh_pico_INCLUDE_DIR zenoh_pico_LIBRARY)

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(zenoh_pico DEFAULT_MSG zenoh_pico_INCLUDE_DIR zenoh_pico_LIBRARY)

set(zenoh_pico_FOUND ${zenoh_pico_FOUND}) # Enforce case-correctness: Set appropriately cased variable...
unset(ZENOH_pico_FOUND) # ...and unset uppercase variable generated by find_package_handle_standard_args

if(${zenoh_pico_FOUND})
  set(zenoh_pico_INCLUDE_DIRS ${zenoh_pico_INCLUDE_DIR})
  set(zenoh_pico_LIBRARIES ${zenoh_pico_LIBRARY})

  add_library(zenoh::zenohpico UNKNOWN IMPORTED)
  set_property(TARGET zenoh::zenohpico PROPERTY IMPORTED_LOCATION ${zenoh_pico_LIBRARY})
  set_property(TARGET zenoh::zenohpico PROPERTY INTERFACE_INCLUDE_DIRECTORIES ${zenoh_pico_INCLUDE_DIR})
  list(APPEND zenoh_pico_TARGETS zenoh::zenohpico)
endif()
