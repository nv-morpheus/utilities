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

# This function uses boost-cmake (https://github.com/Orphis/boost-cmake) to
# configure boost. Not always up to date.
function(morpheus_utils_configure_boost_boost_cmake)
  list(APPEND CMAKE_MESSAGE_CONTEXT "boost")

  set(BOOST_VERSION "1.74.0" CACHE STRING "Version of boost to use")

  find_package(Boost ${BOOST_VERSION} REQUIRED)

  list(POP_BACK CMAKE_MESSAGE_CONTEXT)
endfunction()
