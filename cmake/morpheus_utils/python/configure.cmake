# SPDX-FileCopyrightText: Copyright (c) 2023, NVIDIA CORPORATION & AFFILIATES. All rights reserved.
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

# Get the project name in uppercase if OPTION_PREFIX is not defined
if(NOT DEFINED OPTION_PREFIX)
   string(TOUPPER "${PROJECT_NAME}" OPTION_PREFIX)
endif()

option(${OPTION_PREFIX}_PYTHON_BUILD_STUBS "Whether or not to generated .pyi stub files for C++ Python modules. Disable to avoid requiring loading the NVIDIA GPU Driver during build" ON)
option(${OPTION_PREFIX}_PYTHON_BUILD_WHEEL "Whether or not to build the generated python library into a .whl file" OFF)
option(${OPTION_PREFIX}_PYTHON_INPLACE_BUILD "Whether or not to copy built python modules back to the source tree for debug purposes." OFF)
option(${OPTION_PREFIX}_PYTHON_PERFORM_INSTALL "Whether or not to automatically `pip install` any built python library. WARNING: This may overwrite any existing installation of the same name." OFF)

include("${CMAKE_CURRENT_LIST_DIR}/python_module_tools.cmake")

# Setup common macro for adding some default arguments to adding modules. Use code eval to dynamically generate the
# function prefix
cmake_language(EVAL CODE "
macro(${PROJECT_NAME}_add_pybind11_module)
   # Build up the common arguments for add_pybind11_module
   set(_common_args)

   if(${OPTION_PREFIX}_PYTHON_INPLACE_BUILD)
     list(APPEND _common_args \"COPY_INPLACE\")
   endif()

   if(${OPTION_PREFIX}_PYTHON_BUILD_STUBS)
     list(APPEND _common_args \"BUILD_STUBS\")
   endif()

   # Forward all common arguments plus any arguments passed in
   morpheus_utils_add_pybind11_module(\${ARGN} \${_common_args})
endmacro()

# A common macro for adding some default arguments to add_pybind11_module
macro(${PROJECT_NAME}_add_cython_library)
   # Build up the common arguments for add_pybind11_module
   set(_common_args)

   if(${OPTION_PREFIX}_PYTHON_INPLACE_BUILD)
     list(APPEND _common_args \"COPY_INPLACE\")
   endif()

   if(${OPTION_PREFIX}_PYTHON_BUILD_STUBS)
     list(APPEND _common_args \"BUILD_STUBS\")
   endif()

   # Forward all common arguments plus any arguments passed in
   morpheus_utils_add_cython_library(\${ARGN} \${_common_args})
endmacro()
")
