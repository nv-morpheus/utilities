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

include_guard(DIRECTORY)
include(${CMAKE_CURRENT_LIST_DIR}/../package_config_macros.cmake)
morpheus_utils_package_config_ensure_rapids_cpm_init()

function(morpheus_utils_configure_cudf version)

  list(APPEND CMAKE_MESSAGE_CONTEXT "cudf")

  rapids_cpm_find(cudf ${version}
      GLOBAL_TARGETS
        cudf cudf::cudf
      BUILD_EXPORT_SET
        ${PROJECT_NAME}-exports
      INSTALL_EXPORT_SET
        ${PROJECT_NAME}-exports
      CPM_ARGS
        GIT_REPOSITORY    https://github.com/rapidsai/cudf
        GIT_TAG           branch-${CUDF_VERSION}
        DOWNLOAD_ONLY     TRUE # disable internal builds for now.
        SOURCE_SUBDIR     cpp
        PATCH_COMMAND     git checkout -- .
              COMMAND     git apply --whitespace=fix ${CMAKE_CURRENT_FUNCTION_LIST_DIR}/patches/expose_cudf_column_info.patch
        OPTIONS           USE_NVTX ON
                          BUILD_TESTS OFF
                          BUILD_BENCHMARKS OFF
                          DISABLE_DEPRECATION_WARNING OFF
                          PER_THREAD_DEFAULT_STREAM ON
                          CMAKE_BUILD_TYPE ${CMAKE_BUILD_TYPE}
                          CUDF_CMAKE_CUDA_ARCHITECTURES NATIVE
  )
endfunction()
