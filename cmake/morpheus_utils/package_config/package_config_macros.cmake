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

macro(morpheus_utils_package_config_ensure_rapids_cpm_init)
  if (MORPHEUS_UTILS_RAPIDS_CPM_INITIALIZED OR MORPHEUS_UTILS_NO_CPM_INIT)
    # Do nothing if were already initialized or manually specified
  else()
    if (MORPHEUS_UTILS_RAPIDS_CPM_INIT_OVERRIDE)
      message(STATUS "MORPHEUS_UTILS_RAPIDS_CPM_INIT_OVERRIDE:${MORPHEUS_UTILS_RAPIDS_CPM_INIT_OVERRIDE},
        is set and will be used: ${}")
      rapids_cpm_init(OVERRIDE "${MORPHEUS_UTILS_RAPIDS_CPM_INIT_OVERRIDE}")
      set(MORPHEUS_UTILS_RAPIDS_CPM_INITIALIZED ON)
    else()
      rapids_cpm_init()
    endif()
  endif()
endmacro()
