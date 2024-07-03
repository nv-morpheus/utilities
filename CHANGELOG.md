# utilities 24.06.00 (03 Jul 2024)
There are no changes for v24.06.00.

# utilities 24.03.00 (26 Mar 2024)

## 🚨 Breaking Changes

- Obtain libcudacxx via CCCL, patch matx to include properly. ([#66](https://github.com/nv-morpheus/utilities/pull/66)) [@cwharris](https://github.com/cwharris)

## 🐛 Bug Fixes

- only make triton client depend on zlib in debug builds ([#67](https://github.com/nv-morpheus/utilities/pull/67)) [@cwharris](https://github.com/cwharris)

## 🚀 New Features

- Update ops-bot.yaml ([#68](https://github.com/nv-morpheus/utilities/pull/68)) [@AyodeAwe](https://github.com/AyodeAwe)
- Obtain libcudacxx via CCCL, patch matx to include properly. ([#66](https://github.com/nv-morpheus/utilities/pull/66)) [@cwharris](https://github.com/cwharris)

## 🛠️ Improvements

- Add helper method for configuring grpc ([#63](https://github.com/nv-morpheus/utilities/pull/63)) [@dagardner-nv](https://github.com/dagardner-nv)
- Improving setup scripts between MRC and Morpheus ([#61](https://github.com/nv-morpheus/utilities/pull/61)) [@dagardner-nv](https://github.com/dagardner-nv)

# utilities 23.11.00 (30 Nov 2023)

## 🐛 Bug Fixes

- Fix MatX when building MRC and Morpheus in same environment. ([#55](https://github.com/nv-morpheus/utilities/pull/55)) [@cwharris](https://github.com/cwharris)
- Revert installing pybind11 via conda and patch the dec_ref method ([#52](https://github.com/nv-morpheus/utilities/pull/52)) [@dagardner-nv](https://github.com/dagardner-nv)

## 🛠️ Improvements

- Improve cmake debugging ([#57](https://github.com/nv-morpheus/utilities/pull/57)) [@mdemoret-nv](https://github.com/mdemoret-nv)
- Add option for generating python module from current CMake directory ([#56](https://github.com/nv-morpheus/utilities/pull/56)) [@mdemoret-nv](https://github.com/mdemoret-nv)
- Use `copy-pr-bot` ([#54](https://github.com/nv-morpheus/utilities/pull/54)) [@ajschmidt8](https://github.com/ajschmidt8)
- Update Versions for v23.11.00 ([#49](https://github.com/nv-morpheus/utilities/pull/49)) [@mdemoret-nv](https://github.com/mdemoret-nv)
- Adopt pybind11 v2.10.4 ([#45](https://github.com/nv-morpheus/utilities/pull/45)) [@dagardner-nv](https://github.com/dagardner-nv)

# utilities 23.07.00 (18 Jul 2023)

## 🚨 Breaking Changes

- Changing target names to `build` and `test` for CI runner ([#30](https://github.com/nv-morpheus/utilities/pull/30)) [@mdemoret-nv](https://github.com/mdemoret-nv)

## 🐛 Bug Fixes

- Add conda&#39;s gcov to list of possible names for gcov ([#28](https://github.com/nv-morpheus/utilities/pull/28)) [@dagardner-nv](https://github.com/dagardner-nv)

## 🚀 New Features

- add compiler settings required for doca support ([#39](https://github.com/nv-morpheus/utilities/pull/39)) [@cwharris](https://github.com/cwharris)
- Create label-external-issues.yml ([#37](https://github.com/nv-morpheus/utilities/pull/37)) [@jarmak-nv](https://github.com/jarmak-nv)
- Update default RAPIDS version to 23.02 ([#27](https://github.com/nv-morpheus/utilities/pull/27)) [@cwharris](https://github.com/cwharris)

## 🛠️ Improvements

- Adding a `update-version.sh` script to help with releases ([#47](https://github.com/nv-morpheus/utilities/pull/47)) [@mdemoret-nv](https://github.com/mdemoret-nv)
- Patch matx so that it doesn&#39;t fail when LIBCUDACXX_VERSION is empty ([#44](https://github.com/nv-morpheus/utilities/pull/44)) [@drobison00](https://github.com/drobison00)
- Remove patch from pybind11 ([#43](https://github.com/nv-morpheus/utilities/pull/43)) [@dagardner-nv](https://github.com/dagardner-nv)
- Adopt Matx 0.4.1 ([#42](https://github.com/nv-morpheus/utilities/pull/42)) [@dagardner-nv](https://github.com/dagardner-nv)
- Update Configure_matx.cmake ([#41](https://github.com/nv-morpheus/utilities/pull/41)) [@pdmack](https://github.com/pdmack)
- Adoption MatX fix for Pascal builds ([#38](https://github.com/nv-morpheus/utilities/pull/38)) [@dagardner-nv](https://github.com/dagardner-nv)
- Adopt MatX v0.4.0 ([#36](https://github.com/nv-morpheus/utilities/pull/36)) [@dagardner-nv](https://github.com/dagardner-nv)
- Allow python scripts to be loaded even with missing dependencies ([#35](https://github.com/nv-morpheus/utilities/pull/35)) [@mdemoret-nv](https://github.com/mdemoret-nv)
- Make Cython targets have the same extension as pybind11 ([#34](https://github.com/nv-morpheus/utilities/pull/34)) [@mdemoret-nv](https://github.com/mdemoret-nv)
- Pr template and discussions ([#31](https://github.com/nv-morpheus/utilities/pull/31)) [@jarmak-nv](https://github.com/jarmak-nv)
- Changing target names to `build` and `test` for CI runner ([#30](https://github.com/nv-morpheus/utilities/pull/30)) [@mdemoret-nv](https://github.com/mdemoret-nv)
- Give the conda installed gcov precedence over the OS copy ([#29](https://github.com/nv-morpheus/utilities/pull/29)) [@dagardner-nv](https://github.com/dagardner-nv)
- Set default version of MRC to 23.07 ([#25](https://github.com/nv-morpheus/utilities/pull/25)) [@dagardner-nv](https://github.com/dagardner-nv)

# utilities 23.03.00 (29 Mar 2023)

## 🚨 Breaking Changes

- Improving the python CMake modules to speed up configure step ([#17](https://github.com/nv-morpheus/utilities/pull/17)) [@mdemoret-nv](https://github.com/mdemoret-nv)

## 🐛 Bug Fixes

- Adding better handling to relative paths for python depfile ([#22](https://github.com/nv-morpheus/utilities/pull/22)) [@mdemoret-nv](https://github.com/mdemoret-nv)
- No more buildx, we just set the DOCKER_BUILDKIT=1 ([#16](https://github.com/nv-morpheus/utilities/pull/16)) [@dagardner-nv](https://github.com/dagardner-nv)

## 🛠️ Improvements

- Updating the MRC version to 23.03 ([#21](https://github.com/nv-morpheus/utilities/pull/21)) [@mdemoret-nv](https://github.com/mdemoret-nv)
- Adopt commit 015908f of matx ([#20](https://github.com/nv-morpheus/utilities/pull/20)) [@dagardner-nv](https://github.com/dagardner-nv)
- Disable git shallow checkouts for matx ([#19](https://github.com/nv-morpheus/utilities/pull/19)) [@dagardner-nv](https://github.com/dagardner-nv)
- Use a 32bit build of MatX ([#18](https://github.com/nv-morpheus/utilities/pull/18)) [@dagardner-nv](https://github.com/dagardner-nv)
- Improving the python CMake modules to speed up configure step ([#17](https://github.com/nv-morpheus/utilities/pull/17)) [@mdemoret-nv](https://github.com/mdemoret-nv)
- Adopt matx 0.3.0 and drop patch ([#15](https://github.com/nv-morpheus/utilities/pull/15)) [@dagardner-nv](https://github.com/dagardner-nv)

# utilities 23.01.00 (30 Jan 2023)

## 🛠️ Improvements

- Extraction of common scripts and utilities + cleanup and imrpovements ([#1](https://github.com/nv-morpheus/utilities/pull/1)) [@drobison00](https://github.com/drobison00)
- Update glob string to find all python files ([#2](https://github.com/nv-morpheus/utilities/pull/2)) [@drobison00](https://github.com/drobison00)
- Fix to make BUILD_WHEEL flag function as intended ([#4](https://github.com/nv-morpheus/utilities/pull/4)) [@drobison00](https://github.com/drobison00)
- Add Depfile for Pip Install ([#3](https://github.com/nv-morpheus/utilities/pull/3)) [@mdemoret-nv](https://github.com/mdemoret-nv)
- Fix Message Context in Macros ([#6](https://github.com/nv-morpheus/utilities/pull/6)) [@mdemoret-nv](https://github.com/mdemoret-nv)
- Improve Handling of RAPIDS Versions ([#7](https://github.com/nv-morpheus/utilities/pull/7)) [@mdemoret-nv](https://github.com/mdemoret-nv)
- Fixing some issues after moving the ci/runner scripts to utilities ([#8](https://github.com/nv-morpheus/utilities/pull/8)) [@mdemoret-nv](https://github.com/mdemoret-nv)
- remove broken/unsupported rapids_cpm_find usages in favor of rapids_find_package ([#5](https://github.com/nv-morpheus/utilities/pull/5)) [@cwharris](https://github.com/cwharris)
- Remove the Numpy Dependency from CMake and Revert Boost Config ([#9](https://github.com/nv-morpheus/utilities/pull/9)) [@mdemoret-nv](https://github.com/mdemoret-nv)
- Fix MRC config when building from source ([#11](https://github.com/nv-morpheus/utilities/pull/11)) [@mdemoret-nv](https://github.com/mdemoret-nv)
