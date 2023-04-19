# SPDX-FileCopyrightText: Copyright (c) 2021-2022, NVIDIA CORPORATION & AFFILIATES. All rights reserved.
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

include_guard(GLOBAL)

macro(morpheus_utils_python_configure)
   # Since this is the main entry point, try to load all dependencies
   morpheus_utils_python_load_all()

   include(${MORPHEUS_UTILS_ROOT_PATH}/python/configure.cmake)
endmacro()

macro(morpheus_utils_python_load_python3)
   include(${MORPHEUS_UTILS_ROOT_PATH}/python/ensure_python3.cmake)
endmacro()

macro(morpheus_utils_python_load_pybind11)
   include(${MORPHEUS_UTILS_ROOT_PATH}/python/ensure_pybind11.cmake)
endmacro()

macro(morpheus_utils_python_load_sk_build)
   include(${MORPHEUS_UTILS_ROOT_PATH}/python/ensure_sk_build.cmake)
endmacro()

macro(morpheus_utils_python_load_cython)
   include(${MORPHEUS_UTILS_ROOT_PATH}/python/ensure_cython.cmake)
endmacro()

macro(morpheus_utils_python_ensure_python3)
   # Make sure we loaded the dependency
   morpheus_utils_python_load_python3()

   # Now assert it exists
   morpheus_utils_python_assert_loaded(PYTHON3)
endmacro()

macro(morpheus_utils_python_ensure_sk_build)
   # Make sure we loaded the dependency
   morpheus_utils_python_load_sk_build()

   # Now assert it exists
   morpheus_utils_python_assert_loaded(SKBUILD)
endmacro()

macro(morpheus_utils_python_ensure_pybind11)
   # Make sure we loaded the dependency
   morpheus_utils_python_load_pybind11()

   # Now assert it exists
   morpheus_utils_python_assert_loaded(PYBIND11)
endmacro()

macro(morpheus_utils_python_ensure_cython)
   # Make sure we loaded the dependency
   morpheus_utils_python_load_cython()

   # Now assert it exists
   morpheus_utils_python_assert_loaded(CYTHON)
endmacro()


macro(morpheus_utils_python_load_all)

   # Call all functions
   morpheus_utils_python_load_python3()
   morpheus_utils_python_load_pybind11()
   morpheus_utils_python_load_sk_build()
   morpheus_utils_python_load_cython()
endmacro()

function(morpheus_utils_python_assert_loaded)

   set(prefix ARGS)
   set(flags PYTHON SKBUILD PYBIND11 CYTHON ALL)
   set(singleValues "")
   set(multiValues "")

   include(CMakeParseArguments)
   cmake_parse_arguments(
      "${prefix}"
      "${flags}"
      "${singleValues}"
      "${multiValues}"
      ${ARGN}
   )

   # If nothing is passed, check everything
   if (${ARGC} EQUAL 0)
      set(ARGS_ALL TRUE)
   endif()

   if ((ARGS_PYTHON OR ARGS_ALL) AND NOT _MORPHEUS_UTILS_PYTHON_FOUND_PYTHON3)
      message(FATAL_ERROR "Missing Python3")
   endif()

   if ((ARGS_SKBUILD OR ARGS_ALL) AND NOT _MORPHEUS_UTILS_PYTHON_FOUND_SKBUILD)
      message(FATAL_ERROR "Scikit-build is not installed. CMake may not be able to find Cython. Install scikit-build with `pip install scikit-build`")
   endif()

   if ((ARGS_PYBIND11 OR ARGS_ALL) AND NOT _MORPHEUS_UTILS_PYTHON_FOUND_PYBIND11)
      message(FATAL_ERROR "Missing PYBIND11")
   endif()

   if ((ARGS_CYTHON OR ARGS_ALL) AND NOT _MORPHEUS_UTILS_PYTHON_FOUND_CYTHON)
      message(FATAL_ERROR "Missing CYTHON")
   endif()

endfunction()
