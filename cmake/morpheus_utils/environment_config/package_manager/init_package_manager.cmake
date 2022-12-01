# SPDX-FileCopyrightText: Copyright (c) 2022, NVIDIA CORPORATION & AFFILIATES. All rights reserved.
# SPDX-License-Identifier: Apache-2.0
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

include_guard(GLOBAL)

# Capture the directory where the function is defined
set(MORPHEUS_UTILS_ENVCFG_PM_DIR "${CMAKE_CURRENT_LIST_DIR}")

function(morpheus_utils_initialize_package_manager
    USE_CONDA_VAR_NAME
    VCPKG_TOOLCHAIN_VAR_NAME
    VCPKG_DEFAULT_BINARY_CACHE_VAR_NAME
    )

  set(USE_CONDA ${${USE_CONDA_VAR_NAME}})
  set(VCPKG_TOOLCHAIN ${${VCPKG_TOOLCHAIN_VAR_NAME}})
  set(VCPKG_DEFAULT_BINARY_CACHE ${${VCPKG_DEFAULT_BINARY_CACHE}})

  # Determine if we should use Vcpkg or Conda for dependencies
  if(USE_CONDA)
    # Using conda path. Check for conda environment
    if(NOT DEFINED ENV{CONDA_PREFIX})
      message(WARNING "Option 'MORPHEUS_UTILS_USE_CONDA' is set to ON but no conda environment detected! Ensure you have called `conda activate` before configuring. Third party dependencies are likely to not be found.")
    else()
      message(STATUS "Conda environment detected at '$ENV{CONDA_PREFIX}'. Skipping Vcpkg")
    endif()

    # Disable vcpkg toolchain option (in case the user has switched between the two)
    unset(${VCPKG_TOOLCHAIN_VAR_NAME} CACHE)
  else()
    # Use Vcpkg if variable is set. Must be done before first call to project()!
    # This will automatically install all dependencies in vcpkg.json
    if(NOT DEFINED CACHE{${VCPKG_TOOLCHAIN_VAR_NAME})
      # First run, set this to prevent entering this on a second run
      set(${VCPKG_TOOLCHAIN_VAR_NAME} "" CACHE INTERNAL "Vcpkg Toolchain file to load at startup")

      # Check firs to see if Vcpkg is defined/configured
      if(DEFINED ENV{VCPKG_ROOT})
        if(NOT EXISTS "$ENV{VCPKG_ROOT}")
          message(FATAL_ERROR "Vcpkg env 'VCPKG_ROOT' set to '$ENV{VCPKG_ROOT}' but file does not exist! Exiting...")
          return()
        endif()

        # Set the toolchain file to run
        set(${VCPKG_TOOLCHAIN_VAR_NAME} "$ENV{VCPKG_ROOT}/scripts/buildsystems/vcpkg.cmake" CACHE INTERNAL "")

        # Default Vcpkg cache to
        set(${VCPKG_DEFAULT_BINARY_CACHE_VAR_NAME} "${MRC_CACHE_DIR}/vcpkg" CACHE PATH "The location to use for storing Vcpkg binaries between builds. Defaults to environment variable \$VCPKG_DEFAULT_BINARY_CACHE")
        mark_as_advanced(${VCPKG_DEFAULT_BINARY_CACHE_VAR_NAME})

        # If using shared libs (the default) use a custom triplet file to use dynamic linking
        if(BUILD_SHARED_LIBS)
          set(VCPKG_OVERLAY_TRIPLETS "${CMAKE_CURRENT_FUNCTION_LIST_DIR}/vcpkg_triplets")
          set(VCPKG_TARGET_TRIPLET "x64-linux-dynamic")
        endif()
      else()
        # No Vcpkg. Still continue, but show warning
        message(WARNING "Option '${USE_CONDA_VAR_NAME}' is set to OFF but no 'VCPKG_ROOT' environment set has been detected. When using Vcpkg, either the environment variable 'VCPKG_ROOT' should be set, or 'CMAKE_TOOLCHAIN_FILE' should be specified. Third party dependencies are likely to not be found.")
      endif()
    endif()

    # Check if we have a toolchain file to apply
    if(EXISTS "${${VCPKG_TOOLCHAIN_VAR_NAME}}")
      # Make sure we keep any value set by the user environment
      if(DEFINED ENV{VCPKG_DEFAULT_BINARY_CACHE})
        set(${CPKG_DEFAULT_BINARY_CACHE_VAR_NAME} "$ENV{VCPKG_DEFAULT_BINARY_CACHE}" CACHE INTERNAL "The location to use for storing Vcpkg binaries between builds")
      endif()

      # Now set the environment variable before loading the vcpkg stuff
      set(ENV{VCPKG_DEFAULT_BINARY_CACHE} "${VCPKG_DEFAULT_BINARY_CACHE}")

      # Ensure the cache exists
      if(DEFINED ENV{VCPKG_DEFAULT_BINARY_CACHE} AND NOT EXISTS "$ENV{VCPKG_DEFAULT_BINARY_CACHE}")
        message(STATUS "Vcpkg binary cache missing. Creating directory. Cache location: $ENV{VCPKG_DEFAULT_BINARY_CACHE}")
        file(MAKE_DIRECTORY "$ENV{VCPKG_DEFAULT_BINARY_CACHE}")
      else()
        message(STATUS "Vcpkg binary cache found. Cache location: $ENV{VCPKG_DEFAULT_BINARY_CACHE}")
      endif()

      # Load the toolchain
      include("${${VCPKG_TOOLCHAIN_VAR_NAME}}")
    endif()
  endif()
endfunction()