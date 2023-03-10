#=============================================================================
# Copyright (c) 2020, NVIDIA CORPORATION.
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

function(morpheus_utils_configure_rdkafka) # version currently unused, left for consistency
  list(APPEND CMAKE_MESSAGE_CONTEXT "rdkafka")

  morpheus_utils_assert_cpm_initialized()
  set(RDKAFKA_VERSION 1.6.2 CACHE STRING "Version of RDKafka to use (currently Ignored)")

  rapids_find_generate_module(RDKAFKA
    HEADER_NAMES rdkafkacpp.h
    INCLUDE_SUFFIXES librdkafka
    LIBRARY_NAMES rdkafka++
    BUILD_EXPORT_SET ${PROJECT_NAME}-exports
    INSTALL_EXPORT_SET ${PROJECT_NAME}-exports
  )

  if(DEFINED ENV{RDKAFKA_ROOT})
    # Since this is inside a function the modification of
    # CMAKE_PREFIX_PATH won't leak to other callers/users
    list(APPEND CMAKE_PREFIX_PATH "$ENV{RDKAFKA_ROOT}")
    list(APPEND CMAKE_PREFIX_PATH "$ENV{RDKAFKA_ROOT}/build")
  endif()

  rapids_find_package(RDKAFKA REQUIRED
    BUILD_EXPORT_SET ${PROJECT_NAME}-exports
    INSTALL_EXPORT_SET ${PROJECT_NAME}-exports
  )

  list(POP_BACK CMAKE_MESSAGE_CONTEXT)
endfunction()
