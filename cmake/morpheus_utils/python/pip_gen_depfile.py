# SPDX-FileCopyrightText: Copyright (c) 2023 NVIDIA CORPORATION & AFFILIATES. All rights reserved.
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

import argparse
import os
import sys
import warnings
from importlib.metadata import PackageNotFoundError
from importlib.metadata import distribution


def convert_relative(filename: str, relative_to: str, warn_on_fail=False):

    if (relative_to is None):
        return filename

    rel_filename = os.path.relpath(filename, start=relative_to)

    if (rel_filename.startswith("..")):
        if (warn_on_fail):
            warnings.warn(f"Filename '{filename}' is not relative to {relative_to}. Using absolute path")
    else:
        filename = rel_filename

    return filename


def gen_dep_file(pkg_name: str, input_file: str, output_file: str, relative_to: str = None):

    # Convert the input file to be relative if specified
    input_file = convert_relative(input_file, relative_to=relative_to, warn_on_fail=True)

    try:
        found_dist = distribution(pkg_name)

        joined_files = "".join([
            "\\\n  " + convert_relative(str(found_dist.locate_file(f)), relative_to=relative_to) + " "
            for f in found_dist.files
        ])

        # Create the output lines
        lines = [f"{input_file}: {joined_files}"]

        # Write the depfile
        with open(output_file, "w", encoding="utf-8") as f:
            f.writelines(lines)

    except PackageNotFoundError:
        print(f"Could not find package info for '{pkg_name}'")

        sys.exit(1)


if (__name__ == "__main__"):
    parser = argparse.ArgumentParser(description='Process some integers.')

    parser.add_argument("--pkg_name", type=str, required=True, help='The package name to generate dependencies from')
    parser.add_argument('--input_file', type=str, required=True, help='The file that will depend on the python package')
    parser.add_argument('--output_file', type=str, help='The generated output file. Default is `{input_file}.d`')
    parser.add_argument('--relative_to',
                        type=str,
                        default=None,
                        help='If specified, all files will be relative to this directory')

    args = parser.parse_args()

    if (args.output_file is None):
        args.output_file = args.input_file + ".d"

    gen_dep_file(pkg_name=args.pkg_name,
                 input_file=args.input_file,
                 output_file=args.output_file,
                 relative_to=args.relative_to)
