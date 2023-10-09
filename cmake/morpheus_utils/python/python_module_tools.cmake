# SPDX-FileCopyrightText: Copyright (c) 2022-2023, NVIDIA CORPORATION & AFFILIATES. All rights reserved.
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

# Ensure we only include this once
include_guard(GLOBAL)

#[=======================================================================[
@brief : Creates an artifact set used to build a python wheel
ex. morpheus_utils_create_python_package(package_name)
results --
morpheus_utils_create_python_package <PACKAGE_NAME>
#]=======================================================================]
function(morpheus_utils_create_python_package PACKAGE_NAME)
  list(APPEND CMAKE_MESSAGE_CONTEXT "package-${PACKAGE_NAME}")

  morpheus_utils_python_assert_loaded(PYTHON3)

  set(prefix F_ARGV)
  set(flags "")
  set(singleValues SOURCE_DIRECTORY PROJECT_DIRECTORY)
  set(multiValues "")

  include(CMakeParseArguments)
  cmake_parse_arguments(
      "${prefix}"
      "${flags}"
      "${singleValues}"
      "${multiValues}"
      ${ARGN}
  )

  set(src_dir "${CMAKE_CURRENT_SOURCE_DIR}/${PROJECT_NAME}")
  if(F_ARGV_SOURCE_DIRECTORY)
    set(src_dir "${F_ARGV_SOURCE_DIRECTORY}")
  endif()

  set(project_dir ".")
  if(F_ARGV_PROJECT_DIRECTORY)
    set(project_dir "${F_ARGV_PROJECT_DIRECTORY}")
  endif()

  if(PYTHON_ACTIVE_PACKAGE_NAME)
    message(FATAL_ERROR
        "An active wheel has already been created. Must call morpheus_utils_create_python_package/morpheus_utils_build_python_package in pairs")
  endif()

  message(STATUS "Creating python package '${PACKAGE_NAME}'")

  # Set the active wheel in the parent scope
  set(PYTHON_ACTIVE_PACKAGE_NAME ${PACKAGE_NAME}-package)

  # Create a dummy source that holds all of the source files as resources
  add_custom_target(${PYTHON_ACTIVE_PACKAGE_NAME}-sources ALL)

  # Make it depend on the sources
  add_custom_target(${PYTHON_ACTIVE_PACKAGE_NAME}-modules ALL
    DEPENDS ${PYTHON_ACTIVE_PACKAGE_NAME}-sources
  )

  # Outputs target depends on all sources, generated files, and modules
  add_custom_target(${PYTHON_ACTIVE_PACKAGE_NAME}-outputs ALL
    DEPENDS ${PYTHON_ACTIVE_PACKAGE_NAME}-modules
  )

  # Now setup some simple globbing for common files to move to the build directory
  file(GLOB_RECURSE wheel_python_files
    LIST_DIRECTORIES FALSE
    CONFIGURE_DEPENDS
    "${src_dir}/*.py"
    "${src_dir}/py.typed"
  )

  file(GLOB wheel_python_project_files
      LIST_DIRECTORIES FALSE
      CONFIGURE_DEPENDS
      "${project_dir}/MANIFEST.in"
      "${project_dir}/pyproject.toml"
      "${project_dir}/setup.cfg"
      "${project_dir}/setup.py"
      "${project_dir}/versioneer.py"
  )

  list(APPEND wheel_python_files ${wheel_python_project_files})

  morpheus_utils_add_python_sources(${wheel_python_files})

  # Set the active wheel in the parent scope so it will appear in any subdirectories
  set(PYTHON_ACTIVE_PACKAGE_NAME ${PYTHON_ACTIVE_PACKAGE_NAME} PARENT_SCOPE)

  list(POP_BACK CMAKE_MESSAGE_CONTEXT)
endfunction()

#[=======================================================================[
@brief : Adds all unparsed arguments from the call
as target resources to <target_name>
ex. morpheus_utils_add_target_resources(TARGET_NAME <target_name>)
results --

morpheus_utils_add_target_resources

#]=======================================================================]
function(morpheus_utils_add_target_resources)
  set(flags "")
  set(singleValues TARGET_NAME)
  set(multiValues "")

  include(CMakeParseArguments)
  cmake_parse_arguments(_ARGS
    "${flags}"
    "${singleValues}"
    "${multiValues}"
    ${ARGN}
  )

  morpheus_utils_python_assert_loaded(PYTHON3)

  # Get the current target resources
  get_target_property(target_resources ${_ARGS_TARGET_NAME} RESOURCE)

  set(args_absolute_paths)

  foreach(resource ${_ARGS_UNPARSED_ARGUMENTS})

    cmake_path(ABSOLUTE_PATH resource NORMALIZE OUTPUT_VARIABLE resource_absolute)

    list(APPEND args_absolute_paths "${resource_absolute}")

  endforeach()

  if(target_resources)
    # Append the list of supplied resources
    list(APPEND target_resources "${args_absolute_paths}")
  else()
    set(target_resources "${args_absolute_paths}")
  endif()

  set_target_properties(${_ARGS_TARGET_NAME} PROPERTIES RESOURCE "${target_resources}")

endfunction()

#[=======================================================================[
@brief : Add all <source> elements as resources to the current python
wheel package.
ex. morpheus_utils_add_python_sources([SOURCES...])
results --

morpheus_utils_add_python_sources

#]=======================================================================]
function(morpheus_utils_add_python_sources)
  morpheus_utils_python_assert_loaded(PYTHON3)

  if(NOT PYTHON_ACTIVE_PACKAGE_NAME)
    message(FATAL_ERROR "Must call morpheus_utils_create_python_package() before calling morpheus_utils_add_python_sources")
  endif()

  # Append any arguments to the python_sources_target
  morpheus_utils_add_target_resources(TARGET_NAME ${PYTHON_ACTIVE_PACKAGE_NAME}-sources ${ARGN})

endfunction()

#[=======================================================================[
@brief : Add all <source> elements as resources to the current python
wheel package.
ex. morpheus_utils_add_python_sources([SOURCES...])
results --

morpheus_utils_add_python_sources

#]=======================================================================]
function(morpheus_utils_python_package_set_default_link_targets)
  morpheus_utils_python_assert_loaded(PYTHON3)

  if(NOT PYTHON_ACTIVE_PACKAGE_NAME)
    message(FATAL_ERROR "Must call morpheus_utils_create_python_package() before calling morpheus_utils_set_default_link_targets")
  endif()

  # Save the link targets in the modules target properties
  set_target_properties(${PYTHON_ACTIVE_PACKAGE_NAME}-modules PROPERTIES LINK_TARGETS "${ARGN}")

endfunction()

#[=======================================================================[
@brief : Add custom command to copy all resources for a given
<target_name> to <copy_directory>
ex. morpheus_utils_copy_target_resources(<target name> <copy_dir>
results --

morpheus_utils_copy_target_resources(<TARGET_NAME>
                      <COPY_DIRECTORY>)
#]=======================================================================]
function(morpheus_utils_copy_target_resources TARGET_NAME COPY_DIRECTORY)
  morpheus_utils_python_assert_loaded(PYTHON3)

  # See if there are any resources associated with this target
  get_target_property(target_resources ${TARGET_NAME} RESOURCE)

  if(target_resources)

    # Get the build and src locations
    get_target_property(target_source_dir ${TARGET_NAME} SOURCE_DIR)
    get_target_property(target_binary_dir ${TARGET_NAME} BINARY_DIR)

    set(resource_outputs "")

    # Create the copy command for each resource
    foreach(resource ${target_resources})

      # Get the absolute path of the resource in case its relative.
      cmake_path(ABSOLUTE_PATH resource NORMALIZE)

      cmake_path(IS_PREFIX target_source_dir "${resource}" NORMALIZE is_source_relative)
      cmake_path(IS_PREFIX target_binary_dir "${resource}" NORMALIZE is_binary_relative)

      # Get the relative path to the source or binary directories
      if(is_binary_relative)
        # This must come first because build is relative to source
        cmake_path(RELATIVE_PATH resource BASE_DIRECTORY "${target_binary_dir}" OUTPUT_VARIABLE resource_relative)
      elseif(is_source_relative)
        cmake_path(RELATIVE_PATH resource BASE_DIRECTORY "${target_source_dir}" OUTPUT_VARIABLE resource_relative)
      else()
        message(SEND_ERROR "Target resource is not relative to the source or binary directory. Target: ${TARGET_NAME}, Resource: ${resource}")
      endif()

      # Get the final copied location
      cmake_path(APPEND COPY_DIRECTORY "${resource_relative}" OUTPUT_VARIABLE resource_output)

      # message(VERBOSE "Copying ${resource} to ${resource_output}")

      # Pretty up the output message
      set(top_level_source_dir ${${CMAKE_PROJECT_NAME}_SOURCE_DIR})
      cmake_path(RELATIVE_PATH resource BASE_DIRECTORY "${top_level_source_dir}" OUTPUT_VARIABLE resource_source_relative)
      cmake_path(RELATIVE_PATH resource_output BASE_DIRECTORY "${top_level_source_dir}" OUTPUT_VARIABLE resource_output_source_relative)

      add_custom_command(
        OUTPUT  ${resource_output}
        COMMAND ${CMAKE_COMMAND} -E copy_if_different ${resource} ${resource_output}
        DEPENDS ${resource}
        COMMENT "Copying \${SOURCE_DIR}/${resource_source_relative} to \${SOURCE_DIR}/${resource_output_source_relative}"
      )

      list(APPEND resource_outputs ${resource_output})
    endforeach()

    # Final target to depend on the copied files
    add_custom_target(${TARGET_NAME}-copy-resources ALL
      DEPENDS ${resource_outputs}
    )
  endif()

endfunction()

#[=======================================================================[
@brief : Copy built-in-place resources to an inplace directory
ex. morpheus_utils_copy_target_resources
results --

morpheus_utils_copy_target_resources(<TARGET_NAME>
                      <INPLACE_DIR>)
#]=======================================================================]
function(morpheus_utils_inplace_build_copy TARGET_NAME INPLACE_DIR)
  message(VERBOSE "Inplace build: (${TARGET_NAME}) ${INPLACE_DIR}")

  add_custom_command(
    TARGET ${TARGET_NAME} POST_BUILD
    COMMAND ${CMAKE_COMMAND} -E copy $<TARGET_FILE:${TARGET_NAME}> ${INPLACE_DIR}
    COMMENT "Moving target ${TARGET_NAME} to ${INPLACE_DIR} for inplace build"
  )

  morpheus_utils_copy_target_resources(${TARGET_NAME} ${INPLACE_DIR})

endfunction()

#[=======================================================================[
@brief : Given an active, existing, package definition build a python
wheel if BUILD_WHEEL is set, and install it if INSTALL_WHEEL is set.
ex. morpheus_utils_build_python_package(<package_name> [BUILD_WHEEL] [INSTALL_WHEEL])
results --

morpheus_utils_build_python_package(<PACKAGE_NAME>
                     [BUILD_WHEEL]
                     [INSTALL_WHEEL])
#]=======================================================================]
function(morpheus_utils_build_python_package PACKAGE_NAME)
  morpheus_utils_python_assert_loaded(PYTHON3)

  if(NOT PYTHON_ACTIVE_PACKAGE_NAME)
    message(FATAL_ERROR "Must call morpheus_utils_create_python_package() before calling morpheus_utils_add_python_sources")
  endif()

  if(NOT "${PACKAGE_NAME}-package" STREQUAL "${PYTHON_ACTIVE_PACKAGE_NAME}")
    message(FATAL_ERROR "Mismatched package name supplied to morpheus_utils_create_python_package/morpheus_utils_build_python_package")
  endif()

  set(flags BUILD_WHEEL INSTALL_WHEEL IS_INPLACE)
  set(singleValues "")
  set(multiValues PYTHON_DEPENDENCIES)

  include(CMakeParseArguments)
  cmake_parse_arguments(_ARGS
    "${flags}"
    "${singleValues}"
    "${multiValues}"
    ${ARGN}
  )

  message(STATUS "Finalizing python package '${PACKAGE_NAME}'")

  get_target_property(sources_source_dir ${PYTHON_ACTIVE_PACKAGE_NAME}-sources SOURCE_DIR)
  get_target_property(sources_binary_dir ${PYTHON_ACTIVE_PACKAGE_NAME}-sources BINARY_DIR)

  # First copy the source files
  morpheus_utils_copy_target_resources(${PYTHON_ACTIVE_PACKAGE_NAME}-sources ${sources_binary_dir})

  set(module_dependencies ${PYTHON_ACTIVE_PACKAGE_NAME}-sources-copy-resources)

  if(_ARGS_PYTHON_DEPENDENCIES)
    list(APPEND module_dependencies ${_ARGS_PYTHON_DEPENDENCIES})
  endif()

  # Now ensure that the targets only get built after the files have been copied
  add_dependencies(${PYTHON_ACTIVE_PACKAGE_NAME}-modules ${module_dependencies})

  # Next step is to build the wheel file
  if(_ARGS_BUILD_WHEEL)
    set(wheel_stamp ${sources_binary_dir}/${PYTHON_ACTIVE_PACKAGE_NAME}-wheel.stamp)

    # The command to actually generate the wheel
    add_custom_command(
      OUTPUT ${wheel_stamp}
      COMMAND python setup.py bdist_wheel
      COMMAND ${CMAKE_COMMAND} -E touch ${wheel_stamp}
      WORKING_DIRECTORY ${sources_binary_dir}
      # Depend on any of the output python files
      DEPENDS ${PYTHON_ACTIVE_PACKAGE_NAME}-outputs
      COMMENT "Building ${PACKAGE_NAME} wheel"
    )

    # Create a dummy target to ensure the above custom command is always run
    add_custom_target(${PYTHON_ACTIVE_PACKAGE_NAME}-wheel ALL
      DEPENDS ${wheel_stamp}
    )

    message(STATUS "Creating python wheel for library '${PACKAGE_NAME}'")
  endif()

  # Now build up the pip arguments to either install the package or print a message with the install command
  set(_pip_command)

  list(APPEND _pip_command  "${Python3_EXECUTABLE}" "-m" "pip" "install")

  # detect virtualenv and set Pip args accordingly
  if(NOT DEFINED ENV{VIRTUAL_ENV} AND NOT DEFINED ENV{CONDA_PREFIX})
    list(APPEND _pip_command  "--user")
  endif()

  if("${CMAKE_BUILD_TYPE}" STREQUAL "Debug")
    list(APPEND _pip_command "-e")
  endif()

  # Change which setup we use if we are using inplace
  if(_ARGS_IS_INPLACE)
    list(APPEND _pip_command "${sources_source_dir}")
  else()
    list(APPEND _pip_command "${sources_binary_dir}")
  endif()

  if(_ARGS_INSTALL_WHEEL)
    message(STATUS "Automatically installing Python package '${PACKAGE_NAME}' into current python environment. This may overwrite any existing library with the same name")

    # Now actually install the package
    set(install_stamp ${sources_binary_dir}/${PYTHON_ACTIVE_PACKAGE_NAME}-install.stamp)
    set(install_stamp_depfile ${install_stamp}.d)

    # Need to set CMP0116 to guarantee absolute/reltive paths in the depfile are handled properly
    cmake_policy(PUSH)
    cmake_policy(SET CMP0116 NEW)

    add_custom_command(
      OUTPUT ${install_stamp}
      COMMAND ${_pip_command}
      COMMAND ${CMAKE_COMMAND} -E touch ${install_stamp}
      COMMAND ${Python3_EXECUTABLE} ${CMAKE_CURRENT_FUNCTION_LIST_DIR}/pip_gen_depfile.py --pkg_name ${PACKAGE_NAME} --input_file ${install_stamp} --output_file ${install_stamp_depfile} --relative_to ${CMAKE_CURRENT_BINARY_DIR}
      DEPENDS ${PYTHON_ACTIVE_PACKAGE_NAME}-outputs
      DEPFILE ${install_stamp_depfile}
      COMMENT "Installing ${PACKAGE_NAME} python package"
    )

    cmake_policy(POP)

    add_custom_target(${PYTHON_ACTIVE_PACKAGE_NAME}-install ALL
      DEPENDS ${install_stamp}
    )
  else()
    list(JOIN _pip_command " " _pip_command_str)
    message(STATUS "Python package '${PACKAGE_NAME}' has been built but has not been installed. Use `${_pip_command_str}` to install the library manually")
  endif()

  # Finally, unset the active package
  unset(PYTHON_ACTIVE_PACKAGE_NAME PARENT_SCOPE)
endfunction()

#[=======================================================================[
@brief : given a module name, and potentially a root path, resolves the
fully qualified python module path. If MODULE_ROOT is not provided, it
will default to ${CMAKE_CURRENT_SOURCE_DIR} -- the context of
the caller.

ex. morpheus_utils_resolve_python_module_name(my_module MODULE_ROOT morpheus/_lib)
results --
  MODULE_TARGET_NAME:   morpheus._lib.my_module
  OUTPUT_MODULE_NAME:   my_module
  OUTPUT_RELATIVE_PATH: morpheus/_lib

morpheus_utils_resolve_python_module_name <MODULE_NAME>
                           [MODULE_ROOT]
                           [OUTPUT_TARGET_NAME]
                           [OUTPUT_MODULE_NAME]
                           [OUTPUT_RELATIVE_PATH]
#]=======================================================================]
function(morpheus_utils_resolve_python_module_name MODULE_NAME)
  set(prefix _ARGS) # Prefix parsed args
  set(flags CURRENT_DIR_IS_MODULE)
  set(singleValues
      MODULE_ROOT
      OUTPUT_TARGET_NAME
      OUTPUT_MODULE_NAME
      OUTPUT_RELATIVE_PATH)
  set(multiValues "")

  include(CMakeParseArguments)
  cmake_parse_arguments(${prefix}
      "${flags}"
      "${singleValues}"
      "${multiValues}"
      ${ARGN})

  morpheus_utils_python_assert_loaded(PYTHON3)

  set(py_module_name ${MODULE_NAME})
  set(py_module_namespace "")
  set(py_module_path "")

  if(_ARGS_MODULE_ROOT)
    set(py_module_dir ${CMAKE_CURRENT_SOURCE_DIR})

    if(_ARGS_CURRENT_DIR_IS_MODULE)
      # First, check if the current source directory name matches the module name
      cmake_path(GET py_module_dir STEM py_module_dir_name)

      # Make sure that the current directory has the correct name otherwise creating a module wont work
      if (NOT ("${py_module_dir_name}" STREQUAL "${MODULE_NAME}"))
        message(SEND_ERROR "When creating a python module, the option CURRENT_DIR_IS_MODULE was specified but the "
                           "current directory name does not match the module name. "
                           "Current dir: ${CMAKE_CURRENT_SOURCE_DIR}, Module name: ${MODULE_NAME}")
      endif()

      # Set the module dir to be one up from the current source dir
      cmake_path(GET py_module_dir PARENT_PATH py_module_dir)
    endif()

    file(RELATIVE_PATH py_module_path ${_ARGS_MODULE_ROOT} ${py_module_dir})

    if(NOT ${py_module_path} STREQUAL "")
      # Convert the relative path to a namespace. i.e. `cuml/package/module` -> `cuml::package::module
      # Always add a trailing / to ensure we end with a .
      string(REPLACE "/" "." py_module_namespace "${py_module_path}/")
    endif()
  endif()

  if (_ARGS_OUTPUT_TARGET_NAME)
    set(${_ARGS_OUTPUT_TARGET_NAME} "${py_module_namespace}${py_module_name}" PARENT_SCOPE)
  endif()
  if (_ARGS_OUTPUT_MODULE_NAME)
    set(${_ARGS_OUTPUT_MODULE_NAME} "${py_module_name}" PARENT_SCOPE)
  endif()
  if (_ARGS_OUTPUT_RELATIVE_PATH)
    set(${_ARGS_OUTPUT_RELATIVE_PATH} "${py_module_path}" PARENT_SCOPE)
  endif()
endfunction()

#[=======================================================================[
@brief : Create a new python module from a set of source files
ex. add_python_module
results --

add_python_module

#]=======================================================================]
macro(__create_python_library MODULE_NAME)
  list(APPEND CMAKE_MESSAGE_CONTEXT "module-${MODULE_NAME}")

  set(prefix _ARGS)
  set(flags IS_PYBIND11 IS_CYTHON IS_MODULE COPY_INPLACE BUILD_STUBS CURRENT_DIR_IS_MODULE)
  set(singleValues INSTALL_DEST OUTPUT_TARGET MODULE_ROOT PYX_FILE)
  set(multiValues INCLUDE_DIRS LINK_TARGETS SOURCE_FILES)

  include(CMakeParseArguments)
  cmake_parse_arguments(${prefix}
      "${flags}"
      "${singleValues}"
      "${multiValues}"
      ${ARGN})

  # We always need pybind11 for either
  morpheus_utils_python_assert_loaded(PYBIND11)

  if(NOT _ARGS_NO_PACKAGE AND NOT PYTHON_ACTIVE_PACKAGE_NAME)
    message(FATAL_ERROR "Must call create_python_wheel() before calling morpheus_utils_add_python_sources")
  endif()

  if(NOT _ARGS_MODULE_ROOT)
    get_target_property(_ARGS_MODULE_ROOT ${PYTHON_ACTIVE_PACKAGE_NAME}-modules SOURCE_DIR)
  endif()

  if(NOT _ARGS_LINK_TARGETS)
    get_target_property(_ARGS_LINK_TARGETS ${PYTHON_ACTIVE_PACKAGE_NAME}-modules LINK_TARGETS)
  endif()

  # Normalize the module root
  cmake_path(SET _ARGS_MODULE_ROOT "${_ARGS_MODULE_ROOT}")

  set(extra_args "")

  if(_ARGS_CURRENT_DIR_IS_MODULE)
    set(extra_args "CURRENT_DIR_IS_MODULE")
  endif()

  morpheus_utils_resolve_python_module_name(${MODULE_NAME}
    MODULE_ROOT ${_ARGS_MODULE_ROOT}
    OUTPUT_TARGET_NAME TARGET_NAME
    OUTPUT_MODULE_NAME MODULE_NAME
    OUTPUT_RELATIVE_PATH SOURCE_RELATIVE_PATH
    ${extra_args}
  )

  set(lib_type SHARED)

  if(_ARGS_IS_MODULE)
    set(lib_type MODULE)
  endif()

  # Create the module target
  if(_ARGS_IS_PYBIND11)
    message(VERBOSE "Adding Pybind11 Module: ${TARGET_NAME}")
    pybind11_add_module(${TARGET_NAME} ${lib_type} ${_ARGS_SOURCE_FILES})
  elseif(_ARGS_IS_CYTHON)
    # Make sure we have cython
    morpheus_utils_python_assert_loaded(CYTHON)

    message(VERBOSE "Adding Cython Module: ${TARGET_NAME}")
    add_cython_target(${MODULE_NAME} "${_ARGS_PYX_FILE}" CXX PY3)
    add_library(${TARGET_NAME} ${lib_type} ${${MODULE_NAME}} ${_ARGS_SOURCE_FILES})

    # Make the filename match pybind
    pybind11_extension(${TARGET_NAME})

    # Need to set -fvisibility=hidden for cython according to https://pybind11.readthedocs.io/en/stable/faq.html
    # set_target_properties(${TARGET_NAME} PROPERTIES CXX_VISIBILITY_PRESET hidden)
  else()
    message(FATAL_ERROR "Must specify either IS_PYBIND11 or IS_CYTHON")
  endif()

  set_target_properties(${TARGET_NAME} PROPERTIES PREFIX "")

  if(_ARGS_CURRENT_DIR_IS_MODULE)
    set_target_properties(${TARGET_NAME} PROPERTIES OUTPUT_NAME "__init__")
  else()
    set_target_properties(${TARGET_NAME} PROPERTIES OUTPUT_NAME "${MODULE_NAME}")
  endif()

  set(_link_libs "")
  if(_ARGS_LINK_TARGETS)
    foreach(target IN LISTS _ARGS_LINK_TARGETS)
      list(APPEND _link_libs ${target})
    endforeach()
  endif()

  target_link_libraries(${TARGET_NAME}
    PUBLIC
      ${_link_libs}
  )

  # Tell CMake to use relative paths in the build directory. This is necessary for relocatable packages
  set_target_properties(${TARGET_NAME} PROPERTIES INSTALL_RPATH "${CMAKE_INSTALL_PREFIX}/lib:\$ORIGIN")

  if(_ARGS_INCLUDE_DIRS)
    target_include_directories(${TARGET_NAME}
      PRIVATE
        "${_ARGS_INCLUDE_DIRS}"
    )
  endif()

  # Cython targets need the current dir for generated files
  if(_ARGS_IS_CYTHON)
    target_include_directories(${TARGET_NAME}
      PUBLIC
        "${CMAKE_CURRENT_BINARY_DIR}"
    )
  endif()

  # Set all_python_targets to depend on this module. This ensures that all python targets have been built before any
  # post build actions are taken. This is often necessary to allow post build actions that load the python modules to
  # succeed
  add_dependencies(${PYTHON_ACTIVE_PACKAGE_NAME}-modules ${TARGET_NAME})

  if(_ARGS_BUILD_STUBS)
    # Get the relative path from the project source to the module root
    cmake_path(RELATIVE_PATH _ARGS_MODULE_ROOT BASE_DIRECTORY ${PROJECT_SOURCE_DIR} OUTPUT_VARIABLE module_root_relative)

    cmake_path(APPEND PROJECT_BINARY_DIR ${module_root_relative} OUTPUT_VARIABLE module_root_binary_dir)
    cmake_path(APPEND module_root_binary_dir ${SOURCE_RELATIVE_PATH} ${MODULE_NAME} "__init__.pyi" OUTPUT_VARIABLE module_binary_stub_file)

    # Before installing, create the custom command to generate the stubs
    add_custom_command(
      OUTPUT  ${module_binary_stub_file}
      COMMAND ${Python3_EXECUTABLE} -m pybind11_stubgen ${TARGET_NAME} --no-setup-py --log-level WARN -o ./ --root-module-suffix \"\"
      DEPENDS ${PYTHON_ACTIVE_PACKAGE_NAME}-modules $<TARGET_OBJECTS:${TARGET_NAME}>
      COMMENT "Building stub for python module ${TARGET_NAME}..."
      WORKING_DIRECTORY ${module_root_binary_dir}
    )

    # Add a custom target to ensure the stub generation runs
    add_custom_target(${TARGET_NAME}-stubs ALL
      DEPENDS ${module_binary_stub_file}
    )

    # Make the outputs depend on the stub
    add_dependencies(${PYTHON_ACTIVE_PACKAGE_NAME}-outputs ${TARGET_NAME}-stubs)

    # Save the output as a target property
    morpheus_utils_add_target_resources(TARGET_NAME ${TARGET_NAME} "${module_binary_stub_file}")
  endif()

  if(_ARGS_INSTALL_DEST)
    message(VERBOSE "Install dest: (${TARGET_NAME}) ${_ARGS_INSTALL_DEST}")
    install(
      TARGETS
        ${TARGET_NAME}
      EXPORT
        ${PROJECT_NAME}-exports
      LIBRARY
        DESTINATION
          "${_ARGS_INSTALL_DEST}"
        COMPONENT Wheel
      RESOURCE
        DESTINATION
          "${_ARGS_INSTALL_DEST}/${MODULE_NAME}"
        COMPONENT Wheel
    )
  endif()

  # Set the output target
  if(_ARGS_OUTPUT_TARGET)
    set(${_ARGS_OUTPUT_TARGET} "${TARGET_NAME}" PARENT_SCOPE)
  endif()

  if(_ARGS_COPY_INPLACE)
    # Copy the target inplace
    morpheus_utils_inplace_build_copy(${TARGET_NAME} ${CMAKE_CURRENT_SOURCE_DIR})
  endif()

  list(POP_BACK CMAKE_MESSAGE_CONTEXT)
endmacro()

#[=======================================================================[
@brief : Adds a CMake build target for a new Cython library
ex. morpheus_utils_add_cython_library
results --

morpheus_utils_add_cython_library

#]=======================================================================]
function(morpheus_utils_add_cython_library MODULE_NAME)

  # Check early
  morpheus_utils_python_assert_loaded(CYTHON)

  __create_python_library(${MODULE_NAME} IS_CYTHON ${ARGN})

endfunction()

#[=======================================================================[
@brief : Adds a CMake build target for a new pybind11 module
ex. morpheus_utils_add_pybind1_module
results --

morpheus_utils_add_pybind1_module

#]=======================================================================]
function(morpheus_utils_add_pybind11_module MODULE_NAME)

  # Check early
  morpheus_utils_python_assert_loaded(PYBIND11)

  # Add IS_MODULE to make a MODULE instead of a SHARED
  __create_python_library(${MODULE_NAME} IS_PYBIND11 IS_MODULE ${ARGN})

endfunction()

#[=======================================================================[
@brief : Adds a CMake build target for a new python enabled library -
Note: this differs from a module in that there should be no intention
to import the resulting artifacts directly into Python, and should not
contain any PYBIND11_MODULE calls.
ex. morpheus_utils_add_pybind11_library
results --

morpheus_utils_add_pybind11_library

#]=======================================================================]
function(morpheus_utils_add_pybind11_library MODULE_NAME)

  # Check early
  morpheus_utils_python_assert_loaded(PYBIND11)

  __create_python_library(${MODULE_NAME} IS_PYBIND11 ${ARGN})

endfunction()
