#=============================================================================
# SPDX-FileCopyrightText: Copyright (c) 2023, NVIDIA CORPORATION & AFFILIATES. All rights reserved.
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

# This variable must be set early since many functions use it
set(MORPHEUS_UTILS_RAPIDS_VERSION 23.02 CACHE STRING "The default version to use for RAPIDS libraries unless otherwise specified.")

function(eval_rapids_version input_value output_var_name)

   set(version "${input_value}")

   # Allow setting version to a variable. If so, evaluate that here. Allows for dependent versions, i.e. RMM_VERSION=${MORPHEUS_UTILS_RAPIDS_VERSION}
   if("${version}" MATCHES [=[^\${(.+)}$]=])
      set(version "${${CMAKE_MATCH_1}}")
   endif()

   set(${output_var_name} "${version}" PARENT_SCOPE)

endfunction()
