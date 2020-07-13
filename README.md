# Configure New VM
## Overview
This repository contains a bash script I use to quickly configure VM instances with the 
tools I usually need. There's currently a long list of TODOs, but those should be resolved...someday

## Description of files
Non-Bash Files:

filename                                              |  description
------------------------------------------------------|---------------------------------------------------------
README.md                                             |  Text file (markdown format) description of the project.
notes/TODO.txt                                        |  List of TODOs.
notes/os_release_of_different_platforms.txt           |  Script uses /etc/os-release, so this is a reference

Bash Files:

filename                                              |  description
------------------------------------------------------|---------------------------------------------------------
src/configure_new_vm.sh                               |  Main script

## Dependencies
The only dependencies needed should be already there in the linux distribution.
Stuff like
 - bash
 - sha256sum
 - grep
etc
