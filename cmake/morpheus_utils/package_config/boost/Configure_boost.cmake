#=============================================================================
# SPDX-FileCopyrightText: Copyright (c) 2020-2022, NVIDIA CORPORATION & AFFILIATES. All rights reserved.
# SPDX-License-Identifier: Apache-2.0
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#=============================================================================

include_guard(GLOBAL)

# # This function is for when boost fully supports CMake. As of 1.76.0 the
# # functionality is not supported but is in the master branch. Check in version
# # 1.77
# function(morpheus_utils_configure_boost_true_cmake)
#   list(APPEND CMAKE_MESSAGE_CONTEXT "boost")

#   morpheus_utils_assert_cpm_initialized()
#   set(BOOST_VERSION "1.74.0" CACHE STRING "Version of boost to use")

#   cmake_policy(SET CMP0097 OLD)
#   set(Boost_ENABLE_CMAKE ON)
#   set(Boost_INCLUDE_LIBRARIES "fiber thread" CACHE STRING "")
#   set(Boost_EXCLUDE_LIBRARIES "leaf property_tree" CACHE STRING "")
#   set(Boost_USE_DEBUG_LIBS OFF)  # ignore debug libs

#   rapids_cpm_find(Boost ${BOOST_VERSION}
#     GLOBAL_TARGETS
#       Boost::context Boost::fiber Boost::hana Boost::filesystem Boost::system
#     BUILD_EXPORT_SET
#       ${PROJECT_NAME}-exports
#     INSTALL_EXPORT_SET
#       ${PROJECT_NAME}-exports
#     CPM_ARGS
#       GIT_REPOSITORY          https://github.com/boostorg/boost.git
#       GIT_TAG                 v${BOOST_VERSION}
#       GIT_SHALLOW             TRUE
#       GIT_SUBMODULES          ""
#       OPTIONS                 "BUILD_TESTING OFF"
#       FIND_PACKAGE_ARGUMENTS  "COMPONENTS context fiber filesystem system"
#   )
# endfunction()

# This function uses boost-cmake (https://github.com/Orphis/boost-cmake) to
# configure boost. Not always up to date.
function(morpheus_utils_configure_boost)
  list(APPEND CMAKE_MESSAGE_CONTEXT "boost")

  morpheus_utils_assert_cpm_initialized()
  set(BOOST_VERSION "1.74.0" CACHE STRING "Version of boost to use")

  set(Boost_USE_DEBUG_LIBS OFF)  # ignore debug libs

  rapids_cpm_find(Boost ${BOOST_VERSION}
    GLOBAL_TARGETS
      Boost::context Boost::fiber Boost::hana Boost::filesystem Boost::system
    BUILD_EXPORT_SET
      ${PROJECT_NAME}-exports
    INSTALL_EXPORT_SET
      ${PROJECT_NAME}-exports
    CPM_ARGS
      GIT_REPOSITORY          https://github.com/Orphis/boost-cmake.git
      GIT_TAG                 "7f97a08b64bd5d2e53e932ddf80c40544cf45edf"
      GIT_SHALLOW             TRUE
      OPTIONS                 "BUILD_TESTING OFF"
      FIND_PACKAGE_ARGUMENTS  "COMPONENTS context fiber filesystem system"
  )

  if (NOT Boost_ADDED)
    # Now add it to the list of packages to install
    rapids_export_package(INSTALL Boost
      ${PROJECT_NAME}-exports
      GLOBAL_TARGETS Boost::context Boost::fiber Boost::hana Boost::filesystem Boost::system
    )

    # Overwrite the default package contents
    file(WRITE "${CMAKE_BINARY_DIR}/rapids-cmake/${PROJECT_NAME}-exports/install/package_Boost.cmake" "find_dependency(Boost REQUIRED COMPONENTS context fiber filesystem system)")
  endif()
endfunction()

# function(morpheus_utils_configure_boost)
#   list(APPEND CMAKE_MESSAGE_CONTEXT "boost")

#   set(BOOST_VERSION "1.74.0" CACHE STRING "Version of boost to use")

#   rapids_find_package(Boost
#     GLOBAL_TARGETS
#       Boost::context Boost::fiber Boost::hana Boost::filesystem Boost::system
#     BUILD_EXPORT_SET
#       ${PROJECT_NAME}-exports
#     INSTALL_EXPORT_SET
#       ${PROJECT_NAME}-exports
#     FIND_ARGS
#       ${BOOST_VERSION} REQUIRED COMPONENTS context fiber filesystem system
#   )

#   # Overwrite the default package contents
#   file(WRITE "${CMAKE_BINARY_DIR}/rapids-cmake/${PROJECT_NAME}-exports/install/package_Boost.cmake" "find_dependency(Boost REQUIRED COMPONENTS context fiber filesystem system)")

#   list(POP_BACK CMAKE_MESSAGE_CONTEXT)
# endfunction()
