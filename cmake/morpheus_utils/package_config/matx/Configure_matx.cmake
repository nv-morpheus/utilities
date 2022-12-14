#=============================================================================
# SPDX-FileCopyrightText: Copyright (c) 2020-2022, NVIDIA CORPORATION & AFFILIATES. All rights reserved.
# SPDX-License-Identifier: Apache-2.0
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
#=============================================================================

include_guard(GLOBAL)
include(${CMAKE_CURRENT_LIST_DIR}/../package_config_macros.cmake)
morpheus_utils_package_config_ensure_rapids_cpm_init()

set(MATX_VERSION "0.1.0" CACHE STRING "Version of MatX to use")

function(morpheus_utils_configure_matx)

  list(APPEND CMAKE_MESSAGE_CONTEXT "matx")

  if(CUDAToolkit_FOUND AND (CUDAToolkit_VERSION VERSION_GREATER "11.4"))

    rapids_cpm_find(matx ${MATX_VERSION}
      GLOBAL_TARGETS
        matx matx::matx
      BUILD_EXPORT_SET
        ${PROJECT_NAME}-exports
      INSTALL_EXPORT_SET
        ${PROJECT_NAME}-exports
      CPM_ARGS
        GIT_REPOSITORY  https://github.com/NVIDIA/MatX.git
        GIT_TAG         "v${MATX_VERSION}"
        GIT_SHALLOW     TRUE
        PATCH_COMMAND
          git checkout -- .
          && git apply --whitespace=fix ${CMAKE_CURRENT_FUNCTION_LIST_DIR}/patches/config_and_install_updates.patch
        OPTIONS         "BUILD_EXAMPLES OFF"
                        "BUILD_TESTS OFF"
                        "MATX_INSTALL ON"
    )

  else()
    message(SEND_ERROR
        "Unable to add MatX dependency. CUDA Version must be greater than 11.4.
        Current CUDA Version: ${CUDAToolkit_VERSION}")
  endif()

  list(POP_BACK CMAKE_MESSAGE_CONTEXT)
endfunction()
