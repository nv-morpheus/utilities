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

# Requires sk build
morpheus_utils_python_ensure_sk_build()

morpheus_utils_configure_pybind11()

find_package(pybind11 QUIET)

# Set a variable indicating whether or this was found. We will use this later in
# morpheus_utils_python_assert_loaded()
set(_MORPHEUS_UTILS_PYTHON_FOUND_PYBIND11 ${pybind11_FOUND})
