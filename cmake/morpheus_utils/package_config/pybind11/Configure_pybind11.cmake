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

include_guard(DIRECTORY)

function(morpheus_utils_configure_pybind11 version)

  list(APPEND CMAKE_MESSAGE_CONTEXT "pybind11")

  # Needs a patch to change the internal tracker to use fiber specific storage instead of TSS
  rapids_cpm_find(pybind11 ${version}
    GLOBAL_TARGETS
      pybind11 pybind11::pybind11
    BUILD_EXPORT_SET
      ${PROJECT_NAME}-core-exports
    INSTALL_EXPORT_SET
      ${PROJECT_NAME}-core-exports
    CPM_ARGS
      GIT_REPOSITORY  https://github.com/pybind/pybind11.git
      GIT_TAG         "v${version}"
      GIT_SHALLOW     TRUE
      PATCH_COMMAND   git checkout -- . && git apply --whitespace=fix ${CMAKE_CURRENT_FUNCTION_LIST_DIR}/patches/enable_fiber_support.patch
      OPTIONS         "PYBIND11_INSTALL ON"
                      "PYBIND11_TEST OFF"
  )
endfunction()
