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

function(morpheus_utils_configure_matx)

  list(APPEND CMAKE_MESSAGE_CONTEXT "matx")

  morpheus_utils_assert_cpm_initialized()
  set(MATX_VERSION "0.4.0" CACHE STRING "Version of MatX to use")
  set(MATX_TAG "72c276d" CACHE STRING "Tag of MatX to use")

  if(CUDAToolkit_FOUND AND (CUDAToolkit_VERSION VERSION_GREATER "11.5"))

    # Build MatX with 32 bit indexes, this allows matx size types to match those of cuDF
    rapids_cpm_find(matx ${MATX_VERSION}
      GLOBAL_TARGETS
        matx matx::matx
      BUILD_EXPORT_SET
        ${PROJECT_NAME}-exports
      INSTALL_EXPORT_SET
        ${PROJECT_NAME}-exports
      CPM_ARGS
        GIT_REPOSITORY  https://github.com/NVIDIA/MatX.git
        GIT_TAG         "${MATX_TAG}"
        GIT_SHALLOW     FALSE
        OPTIONS         "MATX_BUILD_32_BIT ON"
                        "MATX_BUILD_BENCHMARKS OFF"
                        "MATX_BUILD_DOCS OFF"
                        "MATX_BUILD_EXAMPLES OFF"
                        "MATX_BUILD_TESTS OFF"
                        "MATX_INSTALL ON"
    )

  else()
    message(SEND_ERROR
        "Unable to add MatX dependency. CUDA Version must be greater than 11.5.
        Current CUDA Version: ${CUDAToolkit_VERSION}")
  endif()

  list(POP_BACK CMAKE_MESSAGE_CONTEXT)
endfunction()
