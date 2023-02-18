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

set(_MORPHEUS_UTILS_PYTHON_DIRECTORY "${CMAKE_CURRENT_LIST_DIR}")

macro(morpheus_utils_python_ensure_python3)
   list(APPEND CMAKE_MODULE_PATH "${_MORPHEUS_UTILS_PYTHON_DIRECTORY}")
   include(ensure_python3)
   list(POP_BACK CMAKE_MODULE_PATH)
endmacro()

macro(morpheus_utils_python_configure)
   list(APPEND CMAKE_MODULE_PATH "${_MORPHEUS_UTILS_PYTHON_DIRECTORY}")
   include(configure)
   list(POP_BACK CMAKE_MODULE_PATH)
endmacro()

macro(morpheus_utils_python_ensure_pybind11)
   list(APPEND CMAKE_MODULE_PATH "${_MORPHEUS_UTILS_PYTHON_DIRECTORY}")
   include(ensure_pybind11)
   list(POP_BACK CMAKE_MODULE_PATH)
endmacro()

macro(morpheus_utils_python_ensure_sk_build)
   list(APPEND CMAKE_MODULE_PATH "${_MORPHEUS_UTILS_PYTHON_DIRECTORY}")
   include(ensure_sk_build)
   list(POP_BACK CMAKE_MODULE_PATH)
endmacro()

macro(morpheus_utils_python_ensure_cython)
   list(APPEND CMAKE_MODULE_PATH "${_MORPHEUS_UTILS_PYTHON_DIRECTORY}")
   include(ensure_cython)
   list(POP_BACK CMAKE_MODULE_PATH)
endmacro()

macro(morpheus_utils_python_ensure_loaded)
   # Call all functions
   morpheus_utils_python_ensure_python3()
   morpheus_utils_python_configure()
   morpheus_utils_python_ensure_pybind11()
   morpheus_utils_python_ensure_sk_build()
   morpheus_utils_python_ensure_cython()
endmacro()
