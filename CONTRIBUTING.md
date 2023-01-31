# Contributing to Morpheus Utilities

Contributions to Morpheus Utilities fall into the following three categories.

1. To report a bug, request a new feature, or report a problem with
    documentation, please file an [issue](https://github.com/nv-morpheus/utilities/issues/new)
    describing in detail the problem or new feature. The Morpheus Utilities team evaluates
    and triages issues, and schedules them for a release. If you believe the
    issue needs priority attention, please comment on the issue to notify the
    team.
2. To propose and implement a new Feature, please file a new feature request
    [issue](https://github.com/nv-morpheus/utilities/issues/new). Describe the
    intended feature and discuss the design and implementation with the team and
    community. Once the team agrees that the plan looks good, go ahead and
    implement it, using the [code contributions](#code-contributions) guide below.
3. To implement a feature or bug-fix for an existing outstanding issue, please
    follow the [code contributions](#code-contributions) guide below. If you
    need more context on a particular issue, please ask in a comment.

As contributors and maintainers to this project,
you are expected to abide by Morpheus Utilities's code of conduct.
More information can be found at: [Contributor Code of Conduct](https://github.com/nv-morpheus/.github/blob/main/CODE_OF_CONDUCT.md).

## Code contributions

### Your first issue

1. Find an issue to work on. The best way is to look for issues with the [good first issue](https://github.com/nv-morpheus/utilities/issues) label.
2. Comment on the issue stating that you are going to work on it.
3. Code! Make sure to update unit tests and confirm that test coverage has not decreased (see below)! Ensure the
[license headers are set properly](#Licensing).
4. When done, [create your pull request](https://github.com/nv-morpheus/utilities/compare).
5. Wait for other developers to review your code and update code as needed.
6. Once reviewed and approved, an Morpheus Utilities developer will merge your pull request.

Remember, if you are unsure about anything, don't hesitate to comment on issues and ask for clarifications!



## Licensing

Morpheus Utilities is licensed under the Apache v2.0 license. All new source files including CMake and other build scripts should contain the Apache v2.0 license header. Any edits to existing source code should update the date range of the copyright to the current year. The format for the license header is:

```c++
/*
 * SPDX-FileCopyrightText: Copyright (c) <year>, NVIDIA CORPORATION & AFFILIATES. All rights reserved.
 * SPDX-License-Identifier: Apache-2.0
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
 ```

### Thirdparty code

Thirdparty code included in the source tree (that is not pulled in as an external dependency) must be compatible with the Apache v2.0 license and should retain the original license along with a url to the source. If this code is modified, it should contain both the Apache v2.0 license followed by the original license of the code and the url to the original code.

Ex:
```c++
/**
 * SPDX-FileCopyrightText: Copyright (c) 2018-2021, NVIDIA CORPORATION & AFFILIATES. All rights reserved.
 * SPDX-License-Identifier: Apache-2.0
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

//
// Original Source: https://github.com/org/other_project
//
// Original License:
// ...
```


---

## Attribution

Portions adopted from https://github.com/pytorch/pytorch/blob/master/CONTRIBUTING.md \
Portions adopted from https://github.com/dask/dask/blob/master/docs/source/develop.rst
