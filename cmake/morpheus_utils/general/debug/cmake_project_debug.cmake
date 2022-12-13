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
    set(options WRITE_TO_FILE PRINT_NOTFOUND)
    set(singleValueArgs WRITE_TO_FILE_NAME)
    set(multiValueArgs TARGETS PROPERTIES)

    include(CMakeParseArguments)
    cmake_parse_arguments(${prefix}
        "${options}"
        "${singleValueArgs}"
        "${multiValueArgs}"
        ${ARGN})

    list(SORT F_ARGV_PROPERTIES)
    list(REMOVE_DUPLICATES F_ARGV_PROPERTIES)
    foreach(CURRENT_TARGET ${F_ARGV_TARGETS})
        set(current_properties_list "")

        message(STATUS "[Target Properties '${CURRENT_TARGET}']")
        message(STATUS "=====================================================")
        foreach(CURRENT_PROPERTY ${F_ARGV_PROPERTIES})
            string(STRIP ${CURRENT_PROPERTY} CURRENT_PROPERTY) # Remove trailing/leading whitespace
            string(REGEX MATCHALL "^[^#].*$" CURRENT_PROPERTY ${CURRENT_PROPERTY}) # Comments hack

            if (NOT CURRENT_PROPERTY)
                continue()
            endif()

            get_target_property(CURRENT_PROPERTY_VALUE ${CURRENT_TARGET} ${CURRENT_PROPERTY})
            if((NOT F_ARGV_PRINT_NOTFOUND) AND ("${CURRENT_PROPERTY_VALUE}" STREQUAL "CURRENT_PROPERTY_VALUE-NOTFOUND"))
            else()
                if ("${CURRENT_PROPERTY_VALUE}" STREQUAL "")
                    set(CURRENT_PROPERTY_VALUE "<EMPTY_STR>")
                else()
                    set(CURRENT_PROPERTY_VALUE "${CURRENT_PROPERTY_VALUE}")
                endif()

                string(JOIN ", " CURRENT_PROPERTY_VALUE ${CURRENT_PROPERTY_VALUE})
                list(APPEND current_properties_list "${CURRENT_PROPERTY} -> \"${CURRENT_PROPERTY_VALUE}\"")
            endif()
        endforeach()

        if (F_ARGV_WRITE_TO_FILE)
            FILE(APPEND "${CMAKE_BINARY_DIR}/morpheus_utils_debug_target_properties.txt" ${current_properties_list})
        endif()

        foreach(PROPERTY_PAIR ${current_properties_list})
            message(STATUS "${PROPERTY_PAIR}")
        endforeach()
    endforeach()
endfunction()