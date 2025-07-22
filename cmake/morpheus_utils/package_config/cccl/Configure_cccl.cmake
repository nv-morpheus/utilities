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

function(morpheus_utils_configure_cccl)
  list(APPEND CMAKE_MESSAGE_CONTEXT "cccl")

  morpheus_utils_assert_cpm_initialized()
  set(cccl_VERSION "2.7.0" CACHE STRING "Version of cccl to use")

  include("${rapids-cmake-dir}/cpm/cccl.cmake")

  # Use rapids-cpm to load cccl. This makes an interface library
  # cccl::cccl that you can link against. If rapids_cpm_libcudaxx is
  # removed, be sure to set `cccl_SOURCE_DIR` since other libraries can
  # depend on this variable. Set it in the parent scope to ensure its valid
  # See: https://github.com/rapidsai/rapids-cmake/issues/117
  rapids_cpm_cccl(
    BUILD_EXPORT_SET
      ${PROJECT_NAME}-exports
    INSTALL_EXPORT_SET
      ${PROJECT_NAME}-exports
  )

  list(POP_BACK CMAKE_MESSAGE_CONTEXT)
endfunction()
