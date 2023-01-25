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

function(morpheus_utils_configure_cudf)
  list(APPEND CMAKE_MESSAGE_CONTEXT "cudf")

  set(CUDF_VERSION "\${MORPHEUS_UTILS_RAPIDS_VERSION}" CACHE STRING "Which version of cuDF to use. Defaults to \${MORPHEUS_UTILS_RAPIDS_VERSION}")

  # Convert to a useable version
  eval_rapids_version(${CUDF_VERSION} CUDF_VERSION)

  rapids_find_package(cudf ${CUDF_VERSION} REQUIRED
    GLOBAL_TARGETS
      cudf cudf::cudf
    BUILD_EXPORT_SET
      ${PROJECT_NAME}-exports
    INSTALL_EXPORT_SET
      ${PROJECT_NAME}-exports
  )

  list(POP_BACK CMAKE_MESSAGE_CONTEXT)
endfunction()
