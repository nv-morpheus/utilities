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
include("${CMAKE_CURRENT_LIST_DIR}/../printing/formatting.cmake")

# Get all propreties that cmake supports
if(NOT CMAKE_PROPERTY_LIST)
    execute_process(COMMAND cmake --help-property-list OUTPUT_VARIABLE CMAKE_PROPERTY_LIST)

    # Convert command output into a CMake list
    string(REGEX REPLACE ";" "\\\\;" CMAKE_PROPERTY_LIST "${CMAKE_PROPERTY_LIST}")
    string(REGEX REPLACE "\n" ";" CMAKE_PROPERTY_LIST "${CMAKE_PROPERTY_LIST}")
endif()

function(morpheus_utils_print_properties)
    message("CMAKE_PROPERTY_LIST = ${CMAKE_PROPERTY_LIST}")
endfunction()

function(morpheus_utils_print_target_properties target)
    if(NOT TARGET ${target})
      message(STATUS "There is no target named '${target}'")
      return()
    endif()

    foreach(property ${CMAKE_PROPERTY_LIST})
        string(REPLACE "<CONFIG>" "${CMAKE_BUILD_TYPE}" property ${property})

        # Fix https://stackoverflow.com/questions/32197663/how-can-i-remove-the-the-location-property-may-not-be-read-from-target-error-i
        if(property STREQUAL "LOCATION" OR property MATCHES "^LOCATION_" OR property MATCHES "_LOCATION$")
            continue()
        endif()

        get_property(was_set TARGET ${target} PROPERTY ${property} SET)
        if(was_set)
            get_target_property(value ${target} ${property})
            message("${target} ${property} = ${value}")
        endif()
    endforeach()
endfunction()

macro(morpheus_utils_get_all_targets_recursive targets dir)
    get_property(subdirectories DIRECTORY ${dir} PROPERTY SUBDIRECTORIES)
    foreach(subdir ${subdirectories})
        morpheus_utils_get_all_targets_recursive(${targets} ${subdir})
    endforeach()

    get_property(current_targets DIRECTORY ${dir} PROPERTY BUILDSYSTEM_TARGETS)
    list(APPEND ${targets} ${current_targets})
endmacro()

function(morpheus_utils_get_all_targets var)
    set(targets)
    morpheus_utils_get_all_targets_recursive(targets ${CMAKE_CURRENT_SOURCE_DIR})
    set(${var} ${targets} PARENT_SCOPE)
endfunction()

function(morpheus_utils_print_all_targets)
    morpheus_utils_get_all_targets(all_targets)
    message("All targets: ${all_targets}")
endfunction()

function(morpheus_utils_print_target_properties)
    set(prefix F_ARGV)
    set(options WRITE_TO_FILE PRINT_NOTFOUND QUIET)
    set(singleValueArgs WRITE_TO_FILE_NAME)
    set(multiValueArgs TARGETS PROPERTIES)

    include(CMakeParseArguments)
    cmake_parse_arguments(${prefix}
        "${options}"
        "${singleValueArgs}"
        "${multiValueArgs}"
        ${ARGN})

    if (NOT F_ARGV_PROPERTIES)
        file(STRINGS "${CMAKE_CURRENT_FUNCTION_LIST_DIR}/cmake_target_properties.txt" F_ARGV_PROPERTIES)
    endif()

    if (F_ARGV_WRITE_TO_FILE)
        set(output_file_name "${F_ARGV_WRITE_TO_FILE_NAME}")
        if ("${output_file_name}" STREQUAL "")
            set(output_file_name "${CMAKE_BINARY_DIR}/morpheus_utils_debug_target_properties.txt")
        endif()
        FILE(WRITE "${output_file_name}" "")
    endif()

    set(max_str_len 0)
    list(SORT F_ARGV_PROPERTIES)
    list(REMOVE_DUPLICATES F_ARGV_PROPERTIES)
    foreach(current_target ${F_ARGV_TARGETS})
        list(APPEND CMAKE_MESSAGE_CONTEXT "target_properties(${current_target})")
        set(current_properties_list "")

        if (NOT F_ARGV_QUIET)
            message(STATUS "[Target Properties '${current_target}']")
            message(STATUS "=====================================================")
        endif()

        foreach(current_property ${F_ARGV_PROPERTIES})
            string(STRIP ${current_property} current_property) # Remove trailing/leading whitespace
            string(REGEX MATCHALL "^[^#].*$" current_property ${current_property}) # Comments hack

            if (NOT current_property)
                continue()
            endif()

            get_target_property(current_property_value ${current_target} ${current_property})
            if((NOT F_ARGV_PRINT_NOTFOUND) AND ("${current_property_value}" STREQUAL "current_property_value-NOTFOUND"))
            else()
                if ("${current_property_value}" STREQUAL "")
                    set(current_property_value "<EMPTY_STR>")
                else()
                    set(current_property_value "${current_property_value}")
                endif()

                string(JOIN ", " current_property_value ${current_property_value})
                list(APPEND current_properties_list "${current_property}" "${current_property_value}")

                string(LENGTH "${current_property}" cur_property_name_length)
                if (${cur_property_name_length} GREATER ${max_str_len})
                    set(max_str_len "${cur_property_name_length}")
                endif()
            endif()
        endforeach()

        set(padded_properties_list "")
        list(LENGTH current_properties_list prop_list_len)
        while(${prop_list_len} GREATER 0)
            list(POP_FRONT current_properties_list current_property current_property_value)
            morpheus_utils_printing_pad_string(${current_property} "\ " "${max_str_len}" cur_property_padded)

            set(padded_property_item "${cur_property_padded} : ${current_property_value}")
            list(APPEND padded_properties_list "${padded_property_item}")

            if (NOT F_ARGV_QUIET)
                message(STATUS "${padded_property_item}")
            endif()
            list(LENGTH current_properties_list prop_list_len)
        endwhile()

        if (NOT F_ARGV_QUIET)
            message(STATUS "=====================================================")
        endif()

        if (F_ARGV_WRITE_TO_FILE)
            string(JOIN "\n" to_write ${padded_properties_list})
            FILE(APPEND "${output_file_name}" "[Target Properties '${current_target}']\n")
            FILE(APPEND "${output_file_name}" "==================================================\n")
            FILE(APPEND "${output_file_name}" "${to_write}\n")
            FILE(APPEND "${output_file_name}" "==================================================\n")
        endif()

        list(POP_BACK CMAKE_MESSAGE_CONTEXT)
    endforeach()
endfunction()

function(morpheus_utils_print_global_properties)
    set(prefix F_ARGV)
    set(options WRITE_TO_FILE PRINT_NOTFOUND QUIET)
    set(singleValueArgs WRITE_TO_FILE_NAME)
    set(multiValueArgs PROPERTIES)

    include(CMakeParseArguments)
    cmake_parse_arguments(${prefix}
        "${options}"
        "${singleValueArgs}"
        "${multiValueArgs}"
        ${ARGN})

    if (NOT F_ARGV_PROPERTIES)
        file(STRINGS "${CMAKE_CURRENT_FUNCTION_LIST_DIR}/cmake_global_properties.txt" F_ARGV_PROPERTIES)
    endif()

    if (F_ARGV_WRITE_TO_FILE)
        set(output_file_name "${F_ARGV_WRITE_TO_FILE_NAME}")
        if ("${output_file_name}" STREQUAL "")
            set(output_file_name "${CMAKE_BINARY_DIR}/morpheus_utils_debug_global_properties.txt")
        endif()
        FILE(WRITE "${output_file_name}" "")
    endif()

    set(max_str_len 0)
    list(SORT F_ARGV_PROPERTIES)
    list(REMOVE_DUPLICATES F_ARGV_PROPERTIES)
    list(APPEND CMAKE_MESSAGE_CONTEXT "global_properties")
    set(current_properties_list "")

    if (NOT F_ARGV_QUIET)
        message(STATUS "[Global Properties]")
        message(STATUS "=====================================================")
    endif()

    foreach(current_property ${F_ARGV_PROPERTIES})
        string(STRIP ${current_property} current_property) # Remove trailing/leading whitespace
        string(REGEX MATCHALL "^[^#].*$" current_property ${current_property}) # Comments hack

        if (NOT current_property)
            continue()
        endif()

        get_cmake_property(current_property_value ${current_property})
        if((NOT F_ARGV_PRINT_NOTFOUND) AND ("${current_property_value}" STREQUAL "current_property_value-NOTFOUND"))
        else()
            if ("${current_property_value}" STREQUAL "")
                set(current_property_value "<EMPTY_STR>")
            else()
                set(current_property_value "${current_property_value}")
            endif()

            string(JOIN ", " current_property_value ${current_property_value})
            list(APPEND current_properties_list "${current_property}" "${current_property_value}")

            string(LENGTH "${current_property}" cur_property_name_length)
            if (${cur_property_name_length} GREATER ${max_str_len})
                set(max_str_len "${cur_property_name_length}")
            endif()
        endif()
    endforeach()

    set(padded_properties_list "")
    list(LENGTH current_properties_list prop_list_len)
    while(${prop_list_len} GREATER 0)
        list(POP_FRONT current_properties_list current_property current_property_value)
        morpheus_utils_printing_pad_string(${current_property} "\ " "${max_str_len}" cur_property_padded)

        set(padded_property_item "${cur_property_padded} : ${current_property_value}")
        list(APPEND padded_properties_list "${padded_property_item}")

        if (NOT F_ARGV_QUIET)
            message(STATUS "${padded_property_item}")
        endif()
        list(LENGTH current_properties_list prop_list_len)
    endwhile()

    if (NOT F_ARGV_QUIET)
        message(STATUS "=====================================================")
    endif()

    if (F_ARGV_WRITE_TO_FILE)
        string(JOIN "\n" to_write ${padded_properties_list})
        FILE(APPEND "${output_file_name}" "[Global Properties]\n")
        FILE(APPEND "${output_file_name}" "==================================================\n")
        FILE(APPEND "${output_file_name}" "${to_write}\n")
        FILE(APPEND "${output_file_name}" "==================================================\n")
    endif()

    list(POP_BACK CMAKE_MESSAGE_CONTEXT)
endfunction()