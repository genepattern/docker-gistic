#!/bin/bash
# copyright 2017-2018 Regents of the University of California and the Broad Institute. All rights reserved.

# (these may be set permanently by copying the above lines into your login script)

export LD_LIBRARY_PATH=/usr/local/MATLAB/MATLAB_Compiler_Runtime/v83/runtime/glnxa64:/usr/local/MATLAB/MATLAB_Compiler_Runtime/v83/bin/glnxa64:/usr/local/MATLAB/MATLAB_Compiler_Runtime/v83/sys/os/glnxa64:$LD_LIBRARY_PATH



#Next, set the XAPPLRESDIR environment variable to the following value:

export XAPPLRESDIR=/usr/local/MATLAB/MATLAB_Compiler_Runtime/v83/X11/app-defaults




echo --- DONE setting up environment variables ---

$@

