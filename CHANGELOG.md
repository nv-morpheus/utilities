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
