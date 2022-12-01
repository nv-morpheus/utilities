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

list(APPEND CMAKE_MODULE_PATH "${CMAKE_CURRENT_LIST_DIR}")

if (MORPHEUS_UTILS_RAPIDS_CPM_INIT_OVERRIDE)
  rapids_cpm_init(OVERRIDE "${MORPHEUS_UTILS_RAPIDS_CPM_INIT_OVERRIDE}")
else()
  rapids_cpm_init()
endif()

include(boost/Configure_boost)
include(cudf/Configure_cudf)
include(expected/Configure_expected)
include(glog/Configure_glog)
include(hwloc/Configure_hwloc)
include(libcudacxx/Configure_libcudacxx)
include(prometheus/Configure_prometheus)
include(pybind11/Configure_pybind11)
include(rmm/Configure_rmm)
include(rxcpp/Configure_rxcpp)
include(taskflow/Configure_taskflow)
include(ucx/Configure_ucx)

list(POP_BACK CMAKE_MODULE_PATH)
