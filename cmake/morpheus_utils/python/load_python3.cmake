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

# Include this once per directory since we set variables
include_guard(DIRECTORY)

# Set both Python and Python3
set(Python3_FIND_VIRTUALENV "FIRST")
set(Python3_FIND_STRATEGY "LOCATION")
set(Python_FIND_VIRTUALENV "FIRST")
set(Python_FIND_STRATEGY "LOCATION")

# Call find_package
find_package(Python3 QUIET
  COMPONENTS Development Development.Module Development.Embed Interpreter
  # Load NumPy as optional. Morpheus uses NumPy, MRC does not.
  OPTIONAL_COMPONENTS NumPy
)

# Call find_package(Python) as well since some use Python3 and others use Python. Just to be safe
find_package(Python QUIET
  COMPONENTS Development Development.Module Development.Embed Interpreter
  # Load NumPy as optional. Morpheus uses NumPy, MRC does not.
  OPTIONAL_COMPONENTS NumPy
)

function(morpheus_utils_print_python_info)
  message(VERBOSE "Python3_EXECUTABLE (before find_package): ${Python3_EXECUTABLE}")
  message(VERBOSE "Python3_ROOT_DIR (before find_package): ${Python3_ROOT_DIR}")
  message(VERBOSE "FIND_PYTHON_STRATEGY (before find_package): ${FIND_PYTHON_STRATEGY}")
  message(VERBOSE "Python3_FOUND: " ${Python3_FOUND})
  message(VERBOSE "Python3_EXECUTABLE: ${Python3_EXECUTABLE}")
  message(VERBOSE "Python3_INTERPRETER_ID: " ${Python3_INTERPRETER_ID})
  message(VERBOSE "Python3_STDLIB: " ${Python3_STDLIB})
  message(VERBOSE "Python3_STDARCH: " ${Python3_STDARCH})
  message(VERBOSE "Python3_SITELIB: " ${Python3_SITELIB})
  message(VERBOSE "Python3_SITEARCH: " ${Python3_SITEARCH})
  message(VERBOSE "Python3_SOABI: " ${Python3_SOABI})
  message(VERBOSE "Python3_INCLUDE_DIRS: " ${Python3_INCLUDE_DIRS})
  message(VERBOSE "Python3_LIBRARIES: " ${Python3_LIBRARIES})
  message(VERBOSE "Python3_LIBRARY_DIRS: " ${Python3_LIBRARY_DIRS})
  message(VERBOSE "Python3_VERSION: " ${Python3_VERSION})
  message(VERBOSE "Python3_NumPy_FOUND: " ${Python3_NumPy_FOUND})
  message(VERBOSE "Python3_NumPy_INCLUDE_DIRS: " ${Python3_NumPy_INCLUDE_DIRS})
  message(VERBOSE "Python3_NumPy_VERSION: " ${Python3_NumPy_VERSION})
endfunction()

# Set a variable indicating whether or this was found. We will use this later in
# morpheus_utils_python_assert_loaded()
set(_MORPHEUS_UTILS_PYTHON_FOUND_PYTHON3 ${Python3_FOUND})
