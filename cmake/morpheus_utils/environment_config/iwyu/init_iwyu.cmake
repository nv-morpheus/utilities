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

include_guard(DIRECTORY)

# Capture the directory where the function is defined
set(MORPHEUS_UTILS_ENVCFG_IWYU_DIR "${CMAKE_CURRENT_LIST_DIR}")

function(morpheus_utils_initialize_iwyu
    USE_IWYU_VAR_NAME
    IWYU_VERBOSITY_VAR_NAME
    IWYU_PROGRAM_VAR_NAME
    IWYU_OPTIONS_VAR_NAME
    USE_CCACHE_VAR_NAME
    )
  list(APPEND CMAKE_MESSAGE_CONTEXT "iwyu")

  set(${IWYU_VERBOSITY_VAR_NAME} "1" CACHE STRING "Set verbosity level for include-what-you-use, 1 is default, 1 only shows recomendations and 11+ prints everything")
  find_program(${IWYU_PROGRAM_VAR_NAME} "include-what-you-use")

  if(${IWYU_PROGRAM_VAR_NAME})
    set(${IWYU_OPTIONS_VAR_NAME}
      -Xiwyu; --mapping_file=${PROJECT_SOURCE_DIR}/ci/iwyu/mappings.imp;
      -Xiwyu; --max_line_length=120;
      -Xiwyu; --verbose=${MRC_IWYU_VERBOSITY};
      -Xiwyu; --no_fwd_decls;
      -Xiwyu; --quoted_includes_first;
      -Xiwyu; --cxx17ns;
      -Xiwyu --no_comments)

    # Convert these to space separated arguments
    string(REPLACE ";" " " ${IWYU_OPTIONS_VAR_NAME} "${${IWYU_OPTIONS_VAR_NAME}}")

    message(STATUS "Enabling include-what-you-use for ${PROJECT_NAME} targets")

    set(IWYU_WRAPPER "${CMAKE_CURRENT_BINARY_DIR}/run_iwyu.sh")

    # Make a ccache runner file with the necessary settings. MRC_CCACHE_OPTIONS must be set!
    set(IWYU_PROGRAM "${${IWYU_PROGRAM_VAR_NAME}}")
    set(IWYU_OPTIONS "${${IWYU_OPTIONS_VAR_NAME}}")

    configure_file("${CMAKE_CURRENT_FUNCTION_LIST_DIR}/templates/run_iwyu.sh.in" "${IWYU_WRAPPER}")

    if(${USE_CCACHE_VAR_NAME})
      set(CMAKE_C_INCLUDE_WHAT_YOU_USE "${CMAKE_CURRENT_BINARY_DIR}/run_ccache_prefix.sh;${IWYU_WRAPPER};${CMAKE_C_COMPILER}" PARENT_SCOPE)
      set(CMAKE_CXX_INCLUDE_WHAT_YOU_USE "${CMAKE_CURRENT_BINARY_DIR}/run_ccache_prefix.sh;${IWYU_WRAPPER};${CMAKE_CXX_COMPILER}" PARENT_SCOPE)
    else()
      set(CMAKE_C_INCLUDE_WHAT_YOU_USE "${IWYU_WRAPPER}" PARENT_SCOPE)
      set(CMAKE_CXX_INCLUDE_WHAT_YOU_USE "${IWYU_WRAPPER}" PARENT_SCOPE)
    endif()

  else()
    message(WARNING "IWYU option ${USE_IWYU_VAR_NAME} is enabled but the include-what-you-use was not found. Check iwyu installation and add the iwyu bin dir to your PATH variable.")
  endif()
endfunction()
