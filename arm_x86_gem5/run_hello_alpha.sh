#! /bin/bash
ARGC=$# #
debug_flag=""
if [[ "$ARGC" == 1 ]]; then # Bad number of arguments.
    debug_flag="--debug-flags=$1"
    echo "debug-flag:$1"	
fi

./build/ALPHA/gem5.opt --outdir=./m5out/alpha $debug_flag \
         ./configs/example/se.py --cpu-type=DerivO3CPU \
          --caches --l1d_size=32kB --l1d_assoc=8 --l1i_size=32kB --l1i_assoc=8 \
          --l2cache --l2_size=2MB --l2_assoc=16 \
         -c ./tests/test-progs/hello/bin/alpha/linux/hello 
