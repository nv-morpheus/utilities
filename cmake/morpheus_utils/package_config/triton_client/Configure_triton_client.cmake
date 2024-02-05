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

include_guard(GLOBAL)

function(morpheus_utils_configure_tritonclient)
  list(APPEND CMAKE_MESSAGE_CONTEXT "TritonClient")

  morpheus_utils_assert_cpm_initialized()
  set(TRITONCLIENT_VERSION "22.10" CACHE STRING "Which version of TritonClient to use")

  # TODO(morpheus#1488): Since the RAPIDS 24.02 upgrade, pybind11_stubgen produces a segmentation fault for the developer guide examples.
  # The triton_client.patch has been updated to work around the segmentation fault by ensuring curl is not initialized as part of a static
  # destructor. We should root-cause why the segmentation fault is occuring for the developer guide examples and not morpheus itself, and
  # attempt to fix the underlying issue, rather than patch Triton Client. Alternatively, we could upstream the Triton Client changes and
  # update out version of Triton Client.

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

  # required for debug builds
  target_link_libraries(httpclient_static
    PRIVATE
      $<$<CONFIG:Debug>:ZLIB::ZLIB>
  )

  list(POP_BACK CMAKE_MESSAGE_CONTEXT)
endfunction()
