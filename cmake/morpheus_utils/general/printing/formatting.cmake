# SPDX-FileCopyrightText: Copyright (c) 2021-2022,NVIDIA CORPORATION & AFFILIATES. All rights reserved.
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

function(morpheus_utils_printing_get_pad_length input pad_to_len output)
    string(LENGTH "${input}" cur_string_length)
    math(EXPR pad_count "${pad_to_len} - ${cur_string_length}")

    set("${output}" ${pad_count} PARENT_SCOPE)
endfunction()

function(morpheus_utils_printing_get_pad_string input padding_char pad_to_len output)
    morpheus_utils_printing_get_pad_length("${input}" ${pad_to_len} pad_count)

    set(output_string "")
    if (${pad_count} GREATER 0)
        string(REPEAT "${padding_char}" "${pad_count}" pad_string)
    endif()

    set("${output}" "${pad_string}" PARENT_SCOPE)
endfunction()

function(morpheus_utils_printing_pad_string input padding_char pad_to_len output)
    morpheus_utils_printing_get_pad_string("${input}" "${padding_char}" "${pad_to_len}" pad_string)

    string(CONCAT output_string "${input}" "${pad_string}")
    set("${output}" "${output_string}" PARENT_SCOPE)
endfunction()