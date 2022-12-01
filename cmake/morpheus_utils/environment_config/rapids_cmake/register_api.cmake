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

# Capture the directory where the function is defined
set(MORPHEUS_UTILS_ENVCFG_RAPIDS_CMAKE_DIR "${CMAKE_CURRENT_LIST_DIR}")

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
