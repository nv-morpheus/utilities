# =============================================================================
# SPDX-FileCopyrightText: Copyright (c) 2020-2022, NVIDIA CORPORATION & AFFILIATES. All rights reserved.
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

function(morpheus_utils_configure_pybind11)
  list(APPEND CMAKE_MESSAGE_CONTEXT "pybind11")

  morpheus_utils_assert_cpm_initialized()
  set(PYBIND11_VERSION "2.10.4" CACHE STRING "Version of Pybind11 to use")

  rapids_find_package(pybind11 ${PYBIND11_VERSION} REQUIRED)

  list(POP_BACK CMAKE_MESSAGE_CONTEXT)
endfunction()
