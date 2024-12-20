<!--
 SPDX-FileCopyrightText: Copyright (c) 2022, NVIDIA CORPORATION & AFFILIATES. All rights reserved.
 SPDX-License-Identifier: Apache-2.0

 Licensed under the Apache License, Version 2.0 (the "License");
 you may not use this file except in compliance with the License.
 You may obtain a copy of the License at

 http://www.apache.org/licenses/LICENSE-2.0

 Unless required by applicable law or agreed to in writing, software
 distributed under the License is distributed on an "AS IS" BASIS,
 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 See the License for the specific language governing permissions and
 limitations under the License.
-->

The `Dockerfile` in this directory defines the images used by the CI runner not for the repo itself.

# Setup
All commands should be run from the repository root. Change directories to the repo root before continuing:

```bash
cd $(git rev-parse --show-toplevel)

# Or if you are in a submodule
cd $(git rev-parse --show-superproject-working-tree)
```

## Optional: Supporting muti-arch builds
To build the images for multiple architectures we will be using qemu, install onto the host system with:
```bash
sudo apt install qemu-utils qemu-system-arm qemu-user-static
```

Register qemu with Docker:
```bash
docker run --rm --privileged multiarch/qemu-user-static --reset -p yes
```

Verify that the registration was successful:
```bash
docker run --platform=linux/arm64/v8 --rm -t rapidsai/ci-conda:cuda12.5.1-ubuntu22.04-py3.10 uname -m
```

If successful, the output should be `aarch64`.

## Optional: Building only for your architecture
For local CI testing of your own architcture, do so by setting `DOCKER_TARGET_ARCH` to the desired architecture. For example, to build for the current architecture:
```bash
export DOCKER_TARGET_ARCH="$(dpkg --print-architecture)"
```


# Building CI images
The `Dockerfile` defines two targets: `build` and `test`. The `build` target is used during the build phase and most likely will not have a GPU. The `test` target is used during the test phase and will have a GPU.

To build the images from the root of the repo run:
```bash
SKIP_PUSH=1 ./external/utilities/ci/runner/build_and_push.sh ./ci/runner
```
Where `./ci/runner` is the path to the directory containing the CI Runner's Dockerfile. Usually this is at `${REPO_ROOT}/ci/runner`.

# Build and push CI images
This will require being a member of the `Morpheus Early Access CI` group in [NGC](https://catalog.ngc.nvidia.com) and logging into the `nvcr.io` registry prior to running.

From the root of the MRC repo run:
```bash
external/utilities/ci/runner/build_and_push.sh
```

If the images are already built, the build step can be skipped by setting `SKIP_BUILD=1`.

# Updating CI to use the new images
Update `.github/workflows/pull_request.yml` changing these two lines with the new image names:
```yaml
      container: nvcr.io/ea-nvidia-morpheus/morpheus:${repo_name}-ci-build-221128
      test_container: nvcr.io/ea-nvidia-morpheus/morpheus:${repo_name}-ci-test-221128
```

Where the final 6 digits of the tag represent the current year, month, and day in the form `YYMMDD`.
