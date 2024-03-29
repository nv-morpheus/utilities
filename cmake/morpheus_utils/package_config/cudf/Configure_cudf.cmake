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

# function(morpheus_utils_configure_cudf)
#   list(APPEND CMAKE_MESSAGE_CONTEXT "cudf")

#   morpheus_utils_assert_cpm_initialized()

#   set(CUDF_VERSION "\${MORPHEUS_UTILS_RAPIDS_VERSION}" CACHE STRING "Which version of cuDF to use. Defaults to \${MORPHEUS_UTILS_RAPIDS_VERSION}")

#   # Convert to a useable version
#   eval_rapids_version(${CUDF_VERSION} CUDF_VERSION)

#   rapids_cpm_find(cudf ${CUDF_VERSION}
#       GLOBAL_TARGETS
#         cudf cudf::cudf
#       BUILD_EXPORT_SET
#         ${PROJECT_NAME}-exports
#       INSTALL_EXPORT_SET
#         ${PROJECT_NAME}-exports
#       CPM_ARGS
#         GIT_REPOSITORY    https://github.com/rapidsai/cudf
#         GIT_TAG           branch-${CUDF_VERSION}
#         DOWNLOAD_ONLY     TRUE # disable internal builds for now.
#         SOURCE_SUBDIR     cpp
#         OPTIONS           USE_NVTX ON
#                           BUILD_TESTS OFF
#                           BUILD_BENCHMARKS OFF
#                           DISABLE_DEPRECATION_WARNING OFF
#                           PER_THREAD_DEFAULT_STREAM ON
#                           CMAKE_BUILD_TYPE ${CMAKE_BUILD_TYPE}
#                           CUDF_CMAKE_CUDA_ARCHITECTURES NATIVE
#   )

#   list(POP_BACK CMAKE_MESSAGE_CONTEXT)
# endfunction()

function(morpheus_utils_configure_cudf)
  list(APPEND CMAKE_MESSAGE_CONTEXT "cudf")

  set(CUDF_VERSION "\${MORPHEUS_UTILS_RAPIDS_VERSION}" CACHE STRING "Which version of cuDF to use. Defaults to \${MORPHEUS_UTILS_RAPIDS_VERSION}")

  # Convert to a useable version
  eval_rapids_version(${CUDF_VERSION} _cudf_version)

  rapids_find_package(cudf ${_cudf_version} REQUIRED
    GLOBAL_TARGETS
      cudf cudf::cudf
    BUILD_EXPORT_SET
      ${PROJECT_NAME}-exports
    INSTALL_EXPORT_SET
      ${PROJECT_NAME}-exports
  )

  list(POP_BACK CMAKE_MESSAGE_CONTEXT)
endfunction()
