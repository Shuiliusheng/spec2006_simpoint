#!/bin/bash 


#判断输入是否合法
ARGC=$# 
if [[ "$ARGC" < 3 ]]
then
    parsec_bench=(blackscholes bodytrack canneal dedup facesim ferret fluidanimate freqmine streamcluster swaptions vips x264 rtview)
    echo "parsec benchmark:"
    echo "     "${parsec_bench[@]}
    echo "./xxx.sh benchmark benchmark_size(test,small,medium,large) ISA(alpha,x86)"
    exit
fi

#input args
ISA=$3
benchmark=$1
benchmark_size=$2

#parsec setting
thread_num=4
script_dir=/home/cuihongwei/server17/fullsystem/benchmark/parsec
script_name=${benchmark}_$thread_num"c_sim"$benchmark_size.rcS


#kernel and disk-image
if [ $ISA = "alpha" -o $ISA = "ALPHA" ];then
    kernel=vmlinux
    disk=alpha_linux-parsec-2-1-m5-with-test-inputs.img
    gem5_arch=ALPHA_MESI_Two_Level/gem5.fast
elif [ $ISA = "arm" -o $ISA = "ARM" ]; then
    echo "not setting"
    exit
else
    kernel=x86_64-vmlinux-2.6.22.9.smp
    disk=x86root-parsec.img
    gem5_arch=X86_MESI_Two_Level/gem5.fast
fi

system_dir=/home/cuihongwei/fullsystem
export M5_PATH=$M5_PATH:$system_dir


#gem5 setting
gem5_dir=/home/cuihongwei/experiment/experiment-gem5/raw-gem5
gem5_config=configs/example/fs.py
#gem5_args=" --num-cpus=4 \
#            --cpu-type=DerivO3CPU --caches --l2cache "

gem5_args="--num-cpus=4 --mem-size=2GB --num-l2caches=4 \
        --num-dirs=4 --network=simple --topology=Mesh_XY --mesh-rows=4 \
        --l1d_assoc=8 --l2_assoc=16 --l1i_assoc=4 \
        --ruby --cpu-type=DerivO3CPU  "

#output setting
gem5_output_dir=/home/cuihongwei/parsec_output

curTime=$(date "+%y%m%d-%H%M%S")
gem5_output_dir=$gem5_output_dir/$ISA/${benchmark}_$thread_num"c_sim"$benchmark_size-$curTime       
mkdir -p $gem5_output_dir
script_out=$gem5_output_dir/runscript.log


#info output

echo "" | tee $script_out
echo "*******************  parsec setting  **********************" | tee -a $script_out
echo "parsec script_dir: "$script_dir | tee -a $script_out
echo "parsec benchmark: "$benchmark | tee -a $script_out
echo "parsec thread_num:  "$thread_num | tee -a $script_out
echo "parsec benchmark_size: "$benchmark_size | tee -a $script_out
echo "parsec script_name: "$script_name | tee -a $script_out
echo "" | tee -a $script_out

echo "*******************  kernel & disk-img setting  **********************" | tee -a $script_out
echo "M5_PATH: "$M5_PATH | tee -a $script_out
echo "kernel: "$kernel | tee -a $script_out
echo "disk: "$disk | tee -a $script_out
echo "" | tee -a $script_out

echo "*******************  gem5 setting  **********************" | tee -a $script_out
echo "gem5_dir: "$gem5_dir | tee -a $script_out
echo "ISA: "$ISA | tee -a $script_out
echo "gem5_config: "$gem5_config | tee -a $script_out
echo "gem5_args: "$gem5_args | tee -a $script_out
echo "gem5_output_dir: "$gem5_output_dir | tee -a $script_out
echo "script_out: "$script_out | tee -a $script_out
echo "" | tee -a $script_out


#gem5 running
echo "********************** simulation ***********************" | tee -a $script_out
echo "start time:(year-mon-day hour-minute-second)"$(date "+%y-%m-%d %H-%M-%S")| tee -a $script_out

$gem5_dir/build/$gem5_arch --outdir=$gem5_output_dir \
    $gem5_dir/$gem5_config $gem5_args \
    --kernel=$kernel --disk-image=$disk \
    --script=$script_dir/$script_name | tee -a $script_out

echo "end time:(year-mon-day hour-minute-second)"$(date "+%y-%m-%d %H-%M-%S")| tee -a $script_out
