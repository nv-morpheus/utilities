# SPDX-FileCopyrightText: Copyright (c) 2021-2022, NVIDIA CORPORATION & AFFILIATES. All rights reserved.
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

# Ensure this is only run once
include_guard(GLOBAL)

macro(morpheus_utils_initialize_cuda_arch project_name)
  list(APPEND CMAKE_MESSAGE_CONTEXT "cuda")

  if(NOT DEFINED CMAKE_CUDA_ARCHITECTURES)
    set(CMAKE_CUDA_ARCHITECTURES "native")
    message(STATUS "CMAKE_CUDA_ARCHITECTURES was not defined. Defaulting to '${CMAKE_CUDA_ARCHITECTURES}' to build only for local architecture. Specify -DCMAKE_CUDA_ARCHITECTURES='ALL' to build for all archs.")
  endif()

  # Initialize CUDA architectures
  rapids_cuda_init_architectures(${project_name})

  list(POP_BACK CMAKE_MESSAGE_CONTEXT)
endmacro()

macro(morpheus_utils_initialize_cuda)
  list(APPEND CMAKE_MESSAGE_CONTEXT "cuda")

  if(NOT DEFINED CMAKE_CUDA_ARCHITECTURES)
    set(CMAKE_CUDA_ARCHITECTURES "native")
    message(STATUS "CMAKE_CUDA_ARCHITECTURES was not defined. Defaulting to '${CMAKE_CUDA_ARCHITECTURES}' to build only for local architecture. Specify -DCMAKE_CUDA_ARCHITECTURES='ALL' to build for all archs.")
  endif()

  # Initialize CUDA architectures
  rapids_cuda_init_architectures(${PROJECT_NAME})

  # Delay enabling CUDA until after we have determined our CXX compiler
  if(NOT DEFINED CMAKE_CUDA_HOST_COMPILER)
  message(STATUS "Setting CUDA host compiler to match CXX compiler: ${CMAKE_CXX_COMPILER}")

  # Only set the host compiler if we arent using clang. Using clang > 8ish is
  # incompatible with CUDA 11.4/11.5/11.6. See Issue #102
  if(NOT "${CMAKE_CXX_COMPILER_ID}" STREQUAL "Clang")
    set(CMAKE_CUDA_HOST_COMPILER ${CMAKE_CXX_COMPILER})
  endif()
  endif()

  if("${CMAKE_CXX_COMPILER_ID}" STREQUAL "Clang")
  # Our version of NVCC officially only supports clang versions 3.2 - 13, we are now using 14
  set(CMAKE_CUDA_FLAGS "${CMAKE_CUDA_FLAGS} -allow-unsupported-compiler")

  # Check if the major version of Clang is greater than 15
  execute_process(COMMAND "${CMAKE_CXX_COMPILER}" "--version"
      OUTPUT_VARIABLE clang_version_info
      ERROR_QUIET OUTPUT_STRIP_TRAILING_WHITESPACE)

  string(REGEX MATCH "version [0-9]+" clang_version_value ${clang_version_info})
  string(REGEX REPLACE "version ([0-9]+)" "\\1" clang_version ${clang_version_value})

  if(${clang_version} VERSION_LESS_EQUAL "15")
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -fcoroutines-ts")
  endif()

  endif()

  # Now enable CUDA
  enable_language(CUDA)

  list(POP_BACK CMAKE_MESSAGE_CONTEXT)
endmacro()

function(morpheus_utils_initialize_package_manager
    USE_CONDA_VAR_NAME
    BUILD_SHARED_LIBS_VAR_NAME
    )

  # Ensure rapids CMake is setup
  include(${CMAKE_CURRENT_FUNCTION_LIST_DIR}/ensure_rapids_cmake_init.cmake)

  set(USE_CONDA ${${USE_CONDA_VAR_NAME}})

  if(USE_CONDA AND DEFINED ENV{CONDA_PREFIX})
    message(STATUS "${USE_CONDA_VAR_NAME} is defined and CONDA environment ($ENV{CONDA_PREFIX}) exists.")
    rapids_cmake_support_conda_env(conda_env MODIFY_PREFIX_PATH)

    if (CMAKE_INSTALL_PREFIX_INITIALIZED_TO_DEFAULT AND DEFINED ENV{CONDA_PREFIX})
      message(STATUS "No CMAKE_INSTALL_PREFIX argument detected, setting to: $ENV{CONDA_PREFIX}")
      set(CMAKE_INSTALL_PREFIX "$ENV{CONDA_PREFIX}" CACHE STRING "" FORCE)
    endif()

    message(STATUS "Prepending CONDA_PREFIX ($ENV{CONDA_PREFIX}) to CMAKE_FIND_ROOT_PATH")
    list(PREPEND CMAKE_FIND_ROOT_PATH "$ENV{CONDA_PREFIX}")
    list(REMOVE_DUPLICATES CMAKE_FIND_ROOT_PATH)
  endif()
endfunction()
