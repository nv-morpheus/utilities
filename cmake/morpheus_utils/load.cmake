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

list(APPEND CMAKE_MODULE_PATH "${CMAKE_CURRENT_LIST_DIR}")

include(environment_config/register_api)
if (MORPHEUS_UTILS_RAPIDS_CMAKE_VERSION)
  morpheus_utils_initialize_rapids_cmake(MORPHEUS_UTILS_RAPIDS_CMAKE_VERSION)
else()
  morpheus_utils_initialize_rapids_cmake(22.08)
endif()

include(package_config/register_api)
include(general/register_api)
include(python/register_api)

list(POP_BACK CMAKE_MODULE_PATH)