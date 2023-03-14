# =============================================================================
# SPDX-FileCopyrightText: Copyright (c) 2020-2022 NVIDIA CORPORATION & AFFILIATES. All rights reserved.
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
# =============================================================================

# ######################################################################################################################
# * CMake properties ------------------------------------------------------------------------------

include_guard(GLOBAL)

function(morpheus_utils_initialize_cpm cache_dir_name)
  list(APPEND CMAKE_MESSAGE_CONTEXT "cpm")

  get_property(is_cpm_initialized GLOBAL PROPERTY CPM_INITIALIZED)

  # Check for the global property
  if (is_cpm_initialized)

    # Now check for the local property
    if (NOT MORPHEUS_UTILS_CPM_INITIALIZED)
      message(WARNING "CPM was initialized from another directory and may not be configured correctly for this project. Ensure morpheus_utils_initialize_cpm() is called from the project root scope")
    endif()

    return()
  endif()

  # Make sure RAPIDS CMake has been loaded
  include(${CMAKE_CURRENT_FUNCTION_LIST_DIR}/../rapids_cmake/ensure_rapids_cmake_init.cmake)

  # Set the CPM cache variable
  set(ENV{CPM_SOURCE_CACHE} "${${cache_dir_name}}/cpm")
  set(CPM_SOURCE_CACHE "${${cache_dir_name}}/cpm" PARENT_SCOPE)

  message(STATUS "Using CPM source cache: $ENV{CPM_SOURCE_CACHE}")

  if (MORPHEUS_UTILS_RAPIDS_CPM_INIT_OVERRIDE)
    message(STATUS "MORPHEUS_UTILS_RAPIDS_CPM_INIT_OVERRIDE:${MORPHEUS_UTILS_RAPIDS_CPM_INIT_OVERRIDE}"
        ", is set and will be used.")
    rapids_cpm_init(OVERRIDE "${MORPHEUS_UTILS_RAPIDS_CPM_INIT_OVERRIDE}")
  else()
    rapids_cpm_init()
  endif()

  # Propagate up any modified local variables that CPM has changed.
  #
  # Push up the modified CMAKE_MODULE_PATh to allow `find_package` calls to find packages that CPM
  # already added.
  set(CMAKE_MODULE_PATH "${CMAKE_MODULE_PATH}" PARENT_SCOPE)

  # # Set the FetchContent default download folder to be the same as CPM
  set(MORPHEUS_UTILS_CPM_INITIALIZED ON PARENT_SCOPE)
endfunction()
