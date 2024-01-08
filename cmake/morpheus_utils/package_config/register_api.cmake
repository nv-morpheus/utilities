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

function(morpheus_utils_assert_cpm_initialized)
   get_property(is_cpm_initialized GLOBAL PROPERTY CPM_INITIALIZED)

   if(NOT is_cpm_initialized)
      message(SEND_ERROR "CPM was not initialized before it was used. Ensure morpheus_utils_initialize_cpm() is called from the most root scope")
   endif()
endfunction()

include(${CMAKE_CURRENT_LIST_DIR}/boost/Configure_boost.cmake)
include(${CMAKE_CURRENT_LIST_DIR}/cudf/Configure_cudf.cmake)
include(${CMAKE_CURRENT_LIST_DIR}/expected/Configure_expected.cmake)
include(${CMAKE_CURRENT_LIST_DIR}/glog/Configure_glog.cmake)
include(${CMAKE_CURRENT_LIST_DIR}/grpc/Configure_grpc.cmake)
include(${CMAKE_CURRENT_LIST_DIR}/hwloc/Configure_hwloc.cmake)
include(${CMAKE_CURRENT_LIST_DIR}/libcudacxx/Configure_libcudacxx.cmake)
include(${CMAKE_CURRENT_LIST_DIR}/matx/Configure_matx.cmake)
include(${CMAKE_CURRENT_LIST_DIR}/mrc/Configure_mrc.cmake)
include(${CMAKE_CURRENT_LIST_DIR}/prometheus/Configure_prometheus.cmake)
include(${CMAKE_CURRENT_LIST_DIR}/pybind11/Configure_pybind11.cmake)
include(${CMAKE_CURRENT_LIST_DIR}/rdkafka/Configure_rdkafka.cmake)
include(${CMAKE_CURRENT_LIST_DIR}/rmm/Configure_rmm.cmake)
include(${CMAKE_CURRENT_LIST_DIR}/rxcpp/Configure_rxcpp.cmake)
include(${CMAKE_CURRENT_LIST_DIR}/taskflow/Configure_taskflow.cmake)
include(${CMAKE_CURRENT_LIST_DIR}/triton_client/Configure_triton_client.cmake)
include(${CMAKE_CURRENT_LIST_DIR}/ucx/Configure_ucx.cmake)
