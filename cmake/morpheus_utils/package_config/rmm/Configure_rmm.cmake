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

  morpheus_utils_assert_cpm_initialized()

  set(RMM_VERSION "${MORPHEUS_UTILS_RAPIDS_VERSION}" CACHE STRING "Version of RMM to use.")

  eval_rapids_version(${RMM_VERSION} _rmm_version)

  # rapids_cpm_find(rmm ${_rmm_version}
  #   GLOBAL_TARGETS
  #     rmm::rmm rmm::Thrust
  #   BUILD_EXPORT_SET
  #     ${PROJECT_NAME}-core-exports
  #   INSTALL_EXPORT_SET
  #     ${PROJECT_NAME}-core-exports
  #   CPM_ARGS
  #     GIT_REPOSITORY  https://github.com/rapidsai/rmm.git
  #     GIT_TAG         branch-${_rmm_version}
  #     GIT_SHALLOW     TRUE
  #     OPTIONS         "BUILD_TESTS OFF"
  #                     "BUILD_BENCHMARKS OFF"
  #                     "CUDA_STATIC_RUNTIME OFF"
  #                     "DISABLE_DEPRECATION_WARNING ${DISABLE_DEPRECATION_WARNINGS}"
  # )


  rapids_find_package(rmm ${_rmm_version} REQUIRED
    GLOBAL_TARGETS
      rmm::rmm rmm::Thrust
    BUILD_EXPORT_SET
      ${PROJECT_NAME}-exports
    INSTALL_EXPORT_SET
      ${PROJECT_NAME}-exports
    CPM_ARGS
      GIT_REPOSITORY  https://github.com/rapidsai/rmm.git
      GIT_TAG         branch-${_rmm_version}
      GIT_SHALLOW     TRUE
      OPTIONS         "BUILD_TESTS OFF"
                      "BUILD_BENCHMARKS OFF"
                      "CUDA_STATIC_RUNTIME OFF"
                      "DISABLE_DEPRECATION_WARNING ${DISABLE_DEPRECATION_WARNINGS}"
  )

  list(POP_BACK CMAKE_MESSAGE_CONTEXT)
endfunction()
