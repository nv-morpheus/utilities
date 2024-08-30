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

function(morpheus_utils_configure_nlohmann_json)
  list(APPEND CMAKE_MESSAGE_CONTEXT "nlohmann_json")

  morpheus_utils_assert_cpm_initialized()
  set(nlohmann_json_VERSION "3.11.3" CACHE STRING "Version of nlohmann_json to use")

  rapids_cpm_find(nlohmann_json ${nlohmann_json_VERSION}
    GLOBAL_TARGETS
      nlohmann_json nlohmann_json::nlohmann_json
    BUILD_EXPORT_SET
      ${PROJECT_NAME}-exports
    INSTALL_EXPORT_SET
      ${PROJECT_NAME}-exports
    CPM_ARGS
        GIT_REPOSITORY          https://github.com/nlohmann/json.git
        GIT_TAG                 "v${nlohmann_json_VERSION}"
        DOWNLOAD_ONLY           TRUE
  )

  list(POP_BACK CMAKE_MESSAGE_CONTEXT)
endfunction()
