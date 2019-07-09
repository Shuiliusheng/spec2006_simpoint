#!/bin/bash
cd /home/cuihongwei/experiment/mcpat-gem5-master/spec2006
source shrc
#specdiff 483.xalancbmk input-1 
specdiff -m -l 10 /home/cuihongwei/experiment/mcpat-gem5-master/spec2006/benchspec/CPU2006/483.xalancbmk/date/ref/output/ref.out /home/cuihongwei/experiment/experiment-gem5/raw-gem5/output/alpha-483.xalancbmk-input1-190425-212223/ref.out
