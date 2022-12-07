# =============================================================================
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
# =============================================================================

include_guard(GLOBAL)
include(${CMAKE_CURRENT_LIST_DIR}/../package_config_macros.cmake)
morpheus_utils_package_config_ensure_rapids_cpm_init()

set(EXPECTED_VERSION "1.0.0" CACHE STRING "Version of expected to use")

function(morpheus_utils_configure_tl_expected)
  list(APPEND CMAKE_MESSAGE_CONTEXT "tl-expected")

  rapids_cpm_find(tl-expected ${EXPECTED_VERSION}
    GLOBAL_TARGETS
      expected tl::expected
    BUILD_EXPORT_SET
      ${PROJECT_NAME}-core-exports
    INSTALL_EXPORT_SET
      ${PROJECT_NAME}-core-exports
    CPM_ARGS
      GIT_REPOSITORY https://github.com/ryanolson/expected.git
      GIT_TAG "5f4b7d2987658cc2a555ce7f4f5b81196461d953"
      GIT_SHALLOW TRUE
      OPTIONS "EXPECTED_BUILD_PACKAGE ON"
  )

  list(POP_BACK CMAKE_MESSAGE_CONTEXT)
endfunction()
