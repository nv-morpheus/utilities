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

function(morpheus_utils_configure_rmm)
  list(APPEND CMAKE_MESSAGE_CONTEXT "rmm")

  include(${CMAKE_CURRENT_FUNCTION_LIST_DIR}/../ensure_cpm_init.cmake)
  set(RMM_VERSION "22.10" CACHE STRING "Version of RMM to use.")

  if ("${RMM_VERSION}" MATCHES [=[^\${(.+)}$]=])
    set(RMM_VERSION "${${CMAKE_MATCH_1}}")
  endif()

  rapids_cpm_find(rmm ${RMM_VERSION}
    GLOBAL_TARGETS
      rmm::rmm rmm::Thrust
    BUILD_EXPORT_SET
      ${PROJECT_NAME}-core-exports
    INSTALL_EXPORT_SET
      ${PROJECT_NAME}-core-exports
    CPM_ARGS
      GIT_REPOSITORY  https://github.com/rapidsai/rmm.git
      GIT_TAG         branch-${RMM_VERSION}
      GIT_SHALLOW     TRUE
      OPTIONS         "BUILD_TESTS OFF"
                      "BUILD_BENCHMARKS OFF"
                      "CUDA_STATIC_RUNTIME OFF"
                      "DISABLE_DEPRECATION_WARNING ${DISABLE_DEPRECATION_WARNINGS}"
  )

  list(POP_BACK CMAKE_MESSAGE_CONTEXT)
endfunction()
