#!/bin/bash
# make specdiff can be used
echo "please use source specdiff.sh to run this script"
cd /home/cuihongwei/experiment/mcpat-gem5-master/spec2006
source shrc
#cd -
#specdiff 400.perlbench input-0 
specdiff -m -l 10 /home/cuihongwei/experiment/mcpat-gem5-master/spec2006/benchspec/CPU2006/400.perlbench/data/test/output/attrs.out /home/cuihongwei/experiment/experiment-gem5/raw-gem5/output/amd64-400.perlbench-input0-190410-174000/attrs.out
