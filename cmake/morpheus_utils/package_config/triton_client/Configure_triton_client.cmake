#=============================================================================
# Copyright (c) 2020-2022, NVIDIA CORPORATION.
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

include_guard(DIRECTORY)
include(${CMAKE_CURRENT_LIST_DIR}/../package_config_macros.cmake)
morpheus_utils_package_config_ensure_rapids_cpm_init()

set(TRITONCLIENT_VERSION "22.08" CACHE STRING "Which version of TritonClient to use")

function(morpheus_utils_configure_tritonclient TRITONCLIENT_VERSION)
  list(APPEND CMAKE_MESSAGE_CONTEXT "TritonClient")

  rapids_cpm_find(TritonClient ${TRITONCLIENT_VERSION}
    GLOBAL_TARGETS
      TritonClient::httpclient TritonClient::httpclient_static TritonClient::grpcclient TritonClient::grpcclient_static
    BUILD_EXPORT_SET
      ${PROJECT_NAME}-exports
    INSTALL_EXPORT_SET
      ${PROJECT_NAME}-exports
    CPM_ARGS
      GIT_REPOSITORY  https://github.com/triton-inference-server/client
      GIT_TAG         r${TRITONCLIENT_VERSION}
      GIT_SHALLOW     TRUE
      SOURCE_SUBDIR   src/c++
      PATCH_COMMAND   git checkout -- .
        && git apply --whitespace=fix ${CMAKE_CURRENT_FUNCTION_LIST_DIR}/patches/triton_client.patch
      OPTIONS         "TRITON_VERSION r${TRITONCLIENT_VERSION}"
                      "TRITON_ENABLE_CC_HTTP ON"
                      "TRITON_ENABLE_CC_GRPC OFF"
                      "TRITON_ENABLE_GPU ON"
                      "TRITON_COMMON_REPO_TAG r${TRITONCLIENT_VERSION}"
                      "TRITON_CORE_REPO_TAG r${TRITONCLIENT_VERSION}"
                      "TRITON_BACKEND_REPO_TAG r${TRITONCLIENT_VERSION}"
  )

  list(POP_BACK CMAKE_MESSAGE_CONTEXT)
endfunction()

