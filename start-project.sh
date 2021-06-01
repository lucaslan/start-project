#!/bin/bash

###########################################
# 2020-08-26
#
# How to use:
# execute it inside the project's directory
###########################################
colours() {
        local codes=()
        if [ "$1" = 'bold' ]; then
                codes=( "${codes[@]}" '1' )
                shift
        fi
        if [ "$#" -gt 0 ]; then          local code=
                case "$1" in
                        red) code=31 ;;
                        green) code=32 ;;
                        yellow) code=33 ;;
                esac
                if [ "$code" ]; then
                        codes=( "${codes[@]}" "$code" )
                fi
        fi
        local IFS=';'
        echo -en '\033['"${codes[*]}"'m'
}


colourize() {
        text="$1"
        shift
        colours "$@"
        echo -n "$text"
        colours reset
        echo
}


function create_readme {
cat << 'EOF'
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)


# Project's name


## Table of Contents
* [About The Project](#About-The-Project)
* [Project architecture](#Project-architecture)
* [API call sample](#API-call-sample)
* [Built With](#Built-With)
* [How to setup](#How-to-setup)
* [License](#License)

## About The Project
`bla` is a super cool project!


## Project architecture
![Project architecture](architecture.png)
you can remove it if there is nothing to add here :)


## API call sample

```json
{
    "sample": sample,
    "super": 100
}
```


## Built With
* Python 3.7
* bash
* love


## How to setup

1. Clone the repo
    ```bash
    git clone **repo link here**
    ```
2. Create a virtual environment
    ```bash
    python3 -m venv .venv
    ```
3. Source the virtual environment and install the project's requirements if required
    ```bash
    source .venv/vin/activate
    ```
    ```bash
    if [[ -f requirements.txt ]]; then pip3 install -r requirements
    ```
3. Run the project
    ```bash
    python3 bla.py
    ```


## License
Distributed under the MIT License. See `LICENSE` for more information.

EOF
}


function generate_license {
cat << EOF
MIT License

Copyright (c) $(date +%Y) Lucas Landim

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.

EOF
}


function create_git_ignore {
cat << EOF
.idea
.venv
.vscode
*.log
playground/*

EOF
}


function check_sucess {
    if [[ $1 -ne 0 ]]; then
        echo -ne "$(colourize "[ ERROR ]" "red")\n"
    else
        echo -ne "$(colourize "[ OK ]" "green")\n"
    fi
}


function user_messages {
case $1 in
    CREATE)
    echo -ne "\n$(colourize "Creating $2 ... " "green")"
    ;;
    CHECK)
    echo -ne "$(colourize "Checking for $2 ... " "yellow")"
    ;;
esac
}


# only create the things that aren't there
user_messages CHECK "Git repository"
if [ ! -d .git ]; then
    # git init .
    user_messages CREATE "Git repository"
    check_sucess $?
else
    check_sucess 0
fi

user_messages CHECK ".gitignore file"
if [ ! -f .gitignore ]; then
    user_messages CREATE ".gitignore file"
    create_git_ignore > .gitignore
    check_sucess $?
else
    check_sucess 0
fi

user_messages CHECK "README.md file"
if [ ! -f README.md ]; then
    # create readme file
    user_messages CREATE "README.md file"
    create_readme > README.md
    check_sucess $?
else
    check_sucess 0
fi

user_messages CHECK "LICENSE file"
if [ ! -f LICENSE ]; then
    # create license file
    user_messages CREATE "LICENSE file"
    generate_license > LICENSE
    check_sucess $?
else
    check_sucess 0
fi
