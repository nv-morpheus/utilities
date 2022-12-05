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
include_guard(DIRECTORY)

macro(morpheus_utils_ensure_rapids_cpm_init)
  if (MORPHEUS_UTILS_RAPIDS_CMAKE_VERSION)
    morpheus_utils_initialize_rapids_cmake(MORPHEUS_UTILS_RAPIDS_CMAKE_VERSION)
    set(_MORPHEUS_UTILS_RAPIDS_CPM_INITIALIZED TRUE CACHE STRING "")
    mark_as_advanced(_MORPHEUS_UTILS_RAPIDS_CPM_INITIALIZED)
  else()
    message(FATAL_ERROR "Must set MORPHEUS_UTILS_RAPIDS_CMAKE_VERSION before loading
    morpheus_utils::rapids_cmake")
  endif()
endmacro()

function(morpheus_utils_initialize_rapids_cmake RAPIDS_VERSION_VAR_NAME)
  set(RAPIDS_CMAKE_VERSION "${${RAPIDS_VERSION_VAR_NAME}}" CACHE STRING "Version of rapids-cmake to use")

  # Download and load the repo according to the rapids-cmake instructions if it does not exist
  if(NOT EXISTS ${CMAKE_BINARY_DIR}/RAPIDS_CMAKE.cmake)
    message(STATUS "Downloading RAPIDS CMake Version: ${RAPIDS_CMAKE_VERSION}")
    file(
      DOWNLOAD https://raw.githubusercontent.com/rapidsai/rapids-cmake/branch-${RAPIDS_CMAKE_VERSION}/RAPIDS.cmake
      ${CMAKE_BINARY_DIR}/RAPIDS_CMAKE.cmake
    )
  endif()

  # Now load the file
  include(${CMAKE_BINARY_DIR}/RAPIDS_CMAKE.cmake)

  # Load Rapids Cmake packages
  include(rapids-cmake)
  include(rapids-cpm)
  include(rapids-cuda)
  include(rapids-export)
  include(rapids-find)
endfunction()

macro(morpheus_utils_initialize_cuda_arch project_name)
  message(STATUS "Configuring CUDA Architecture")

  # Default to using "" for CUDA_ARCHITECTURES to build based on GPU in system
  if(NOT DEFINED CMAKE_CUDA_ARCHITECTURES)
    set(CMAKE_CUDA_ARCHITECTURES "")
    message(STATUS "CMAKE_CUDA_ARCHITECTURES was not defined. Defaulting to '' to build only for local architecture. "
        "Specify -DCMAKE_CUDA_ARCHITECTURES='ALL' to build for all archs.")
  endif()

  # Initialize CUDA architectures
  rapids_cuda_init_architectures(${project_name})
endmacro()

function(morpheus_utils_initialize_package_manager
    USE_CONDA_VAR_NAME
    BUILD_SHARED_LIBS_VAR_NAME
    )

  morpheus_utils_ensure_rapids_cpm_init()
  set(USE_CONDA ${${USE_CONDA_VAR_NAME}})

  if(DEFINED CMAKE_TOOLCHAIN_FILE)
    message(STATUS "[CMAKE_TOOLCHAIN_FILE] is defined (${CMAKE_TOOLCHAIN_FILE}), using custom toolchain")
    message(STATUS "Conda environment variables will be ignored.")
  elseif (USE_CONDA AND DEFINED ENV{CONDA_PREFIX})
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
