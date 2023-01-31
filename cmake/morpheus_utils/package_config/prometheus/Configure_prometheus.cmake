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

function(morpheus_utils_configure_prometheus_cpp)
  list(APPEND CMAKE_MESSAGE_CONTEXT "prometheus_cpp")

  include(${CMAKE_CURRENT_FUNCTION_LIST_DIR}/../ensure_cpm_init.cmake)
  set(PROMETHEUS_CPP_VERSION "1.0.0" CACHE STRING "Version of Prometheus-cpp to use")

  rapids_cpm_find(prometheus-cpp ${PROMETHEUS_CPP_VERSION}
    GLOBAL_TARGETS
      prometheus-cpp prometheus-cpp::core
    BUILD_EXPORT_SET
      ${PROJECT_NAME}-core-exports
    INSTALL_EXPORT_SET
      ${PROJECT_NAME}-core-exports
    CPM_ARGS
      GIT_REPOSITORY https://github.com/jupp0r/prometheus-cpp.git
      GIT_TAG "v${PROMETHEUS_CPP_VERSION}"
      GIT_SHALLOW TRUE
      PATCH_COMMAND   git checkout -- . && git apply --whitespace=fix ${CMAKE_CURRENT_FUNCTION_LIST_DIR}/patches/exports_fix.patch
      OPTIONS "BUILD_SHARED_LIBS OFF"
              "ENABLE_PULL OFF"
              "ENABLE_PUSH OFF"
              "ENABLE_COMPRESSION OFF"
              "ENABLE_TESTING OFF"
              "USE_THIRDPARTY_LIBRARIES OFF"
              "OVERRIDE_CXX_STANDARD_FLAGS OFF"
              "THIRDPARTY_CIVETWEB_WITH_SSL OFF"
              "GENERATE_PKGCONFIG OFF"
  )

  list(POP_BACK CMAKE_MESSAGE_CONTEXT)
endfunction()
