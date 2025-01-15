#!/bin/bash
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

# Get the repo name from git. Either Morpheus or MRC
REPO_NAME=$(basename -s .git `git config --get remote.origin.url`)

# Convert it to lower
REPO_NAME=$(echo "${REPO_NAME}" | tr '[:upper:]' '[:lower:]')

DOCKER_TARGET=${DOCKER_TARGET:-"build" "test"}
DOCKER_TARGET_ARCH=${DOCKER_TARGET_ARCH:-"arm64" "amd64"}
DOCKER_BUILDKIT=${DOCKER_BUILDKIT:-1}
DOCKER_REGISTRY_SERVER=${DOCKER_REGISTRY_SERVER:-"nvcr.io"}
DOCKER_REGISTRY_PATH=${DOCKER_REGISTRY_PATH:-"/ea-nvidia-morpheus/morpheus"}
DOCKER_TAG_PREFIX=${DOCKER_TAG_PREFIX:-"${REPO_NAME}-ci"}
DOCKER_TAG_POSTFIX=${DOCKER_TAG_POSTFIX:-"$(date +'%y%m%d')"}
DOCKER_EXTRA_ARGS=${DOCKER_EXTRA_ARGS:-""}

SKIP_BUILD=${SKIP_BUILD:-""}
SKIP_PUSH=${SKIP_PUSH:-""}

set -e

# Get the runner context from the user supplied argument or default to ci/runner
RUNNER_CONTEXT=${1:-./ci/runner}

function get_image_short_name() {
   echo "${DOCKER_REGISTRY_SERVER}${DOCKER_REGISTRY_PATH}:${DOCKER_TAG_PREFIX}-${build_target}-${DOCKER_TAG_POSTFIX}"
}

function get_image_full_name() {
   echo "$(get_image_short_name)-${build_arch}"
}

function get_real_arch() {
    case ${1} in
        "amd64")
            echo "x86_64"
            ;;
        "arm64")
            echo "aarch64"
            ;;
        *)
            echo "unknown"
            ;;
    esac
}

if [[ "${SKIP_BUILD}" == "" ]]; then
    for build_target in ${DOCKER_TARGET[@]}; do
        for build_arch in ${DOCKER_TARGET_ARCH[@]}; do
            FULL_NAME=$(get_image_full_name)
            REAL_ARCH=$(get_real_arch ${build_arch})
            echo "Building target ${build_arch} ${build_target} as ${FULL_NAME}";
            docker build \
                --platform=linux/${build_arch} \
                --network=host \
                --build-arg REAL_ARCH=${REAL_ARCH} \
                ${DOCKER_EXTRA_ARGS} \
                --target ${build_target} \
                -t ${FULL_NAME} \
                -f ${RUNNER_CONTEXT}/Dockerfile .
        done
    done


fi

if [[ "${SKIP_PUSH}" == "" ]]; then
    for build_target in ${DOCKER_TARGET[@]}; do
        SHORT_NAME=$(get_image_short_name)
        AMEND_ARGS=()
        for build_arch in ${DOCKER_TARGET_ARCH[@]}; do
            FULL_NAME=$(get_image_full_name)
            echo "Pushing ${FULL_NAME}";
            docker push ${FULL_NAME}
        done
        AMEND_ARGS+=(--amend ${FULL_NAME})

        echo "Creating Manifest"
        docker manifest create ${SHORT_NAME} ${AMEND_ARGS[@]}

        echo "Pushing ${SHORT_NAME}";
        docker manifest push ${SHORT_NAME}
    done
fi
