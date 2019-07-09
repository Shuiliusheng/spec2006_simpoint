#!/bin/bash
#判断输入是否合法
ARGC=$#
if [[ "$ARGC" < 3 ]]
then
	echo "./run_spec.sh int/fp/all/400 test/ref/all ISA(arm,x86,alpha,mips,riscv) (diff)"
    exit
fi
shell_name=spec2006-diff.sh

bench_int=(400.perlbench   401.bzip2  403.gcc  429.mcf  445.gobmk  456.hmmer  458.sjeng  462.libquantum  464.h264ref  471.omnetpp  473.astar  483.xalancbmk)
number_int=(4 7 10 2 6 3 2 2 4 2 3 2)
num_int=12

bench_fp=(410.bwaves 416.gamess 433.milc 434.zeusmp 435.gromacs 436.cactusADM 437.leslie3d 444.namd 447.dealII 450.soplex 453.povray 454.calculix 459.GemsFDTD 465.tonto 470.lbm 481.wrf 482.sphinx3)
number_fp=(2 4 2 2 2 2 2 2 2 3 2 2 2 2 2 2 2)
num_fp=17

find_number(){
	for((i=0;i<$num_int;i++))
	do
		if [ "$1" = "${bench_int[$i]:0:3}" -o "$1" = "${bench_int[$i]:4}" -o "$1" = "${bench_int[$i]}" ]; 
		then 
			return ${number_int[$i]}
		fi
	done
	for((i=0;i<$num_fp;i++))
	do
		if [ "$1" = "${bench_fp[$i]:0:3}" -o "$1" = "${bench_fp[$i]:4}" -o "$1" = "${bench_fp[$i]}" ]; 
		then 
			return ${number_fp[$i]}
		fi
	done
	return -1
}

if [ "$1" = "all" ]; then
	if [ "$2" = "all" ]; then
		echo "run spec2006 for all benchmark with all inputs!"
		for((i=0;i<$num_int;i++))
		do
			echo "running Bench-INT $i : ${bench_int[$i]}"
			for((j=0;j<${number_int[$i]};j++))
			do
				bash ${shell_name} ${bench_int[$i]} $j $3 $4
			done
			echo ""
		done
		for((i=0;i<$num_fp;i++))
		do
			echo "running Bench-FP $i : ${bench_fp[$i]}"
			for((j=0;j<${number_fp[$i]};j++))
			do
				bash ${shell_name} ${bench_fp[$i]} $j $3 $4
			done
			echo ""
		done
	elif [ "$2" = "test" ]; then
		echo "run spec2006 for all benchmark with test input !"
		for((i=0;i<$num_int;i++))
		do
			echo "running Bench-INT $i : ${bench_int[$i]}"
			echo "*** input test-1"
			bash ${shell_name} ${bench_int[$i]} 0 $3 $4
			echo ""
		done
		for((i=0;i<$num_fp;i++))
		do
			echo "running Bench-FP $i : ${bench_fp[$i]}"
			echo "*** input test-1"
			bash ${shell_name} ${bench_fp[$i]} 0 $3 $4
			echo ""
		done
	elif [ "$2" = "ref" ]; then
		echo "run spec2006 for all benchmark with all ref inputs!"
		for((i=0;i<$num_int;i++))
		do
			echo "running Bench-INT $i : ${bench_int[$i]}"
			for((j=1;j<${number_int[$i]};j++))
			do
				echo "*** input ref-$j"
				bash ${shell_name} ${bench_int[$i]} $j $3 $4
			done
			echo ""
		done
		for((i=0;i<$num_fp;i++))
		do
			echo "running Bench-FP $i : ${bench_fp[$i]}"
			for((j=1;j<${number_fp[$i]};j++))
			do
				echo "*** input ref-$j"
				bash ${shell_name} ${bench_fp[$i]} $j $3 $4
			done
			echo ""
		done
	else
		echo "run spec2006 for all benchmark with input-$2 !"
		for((i=0;i<$num_int;i++))
		do
			echo "running Bench-INT $i : ${bench_int[$i]}"
			echo "*** input-$2"
			bash ${shell_name} ${bench_int[$i]} $2 $3 $4
			echo ""
		done
		for((i=0;i<$num_fp;i++))
		do
			echo "running Bench-FP $i : ${bench_fp[$i]}"
			echo "*** input-$2"
			bash ${shell_name} ${bench_fp[$i]} $2 $3 $4
			echo ""
		done
	fi
elif [ "$1" = "int" ]; then
	if [ "$2" = "all" ]; then
		echo "run spec2006 for all benchmark with all inputs!"
		for((i=0;i<$num_int;i++))
		do
			echo "running Bench-INT $i : ${bench_int[$i]}"
			for((j=0;j<${number_int[$i]};j++))
			do
				bash ${shell_name} ${bench_int[$i]} $j $3 $4
			done
			echo ""
		done
	elif [ "$2" = "test" ]; then
		echo "run spec2006 for all benchmark with test input !"
		for((i=0;i<$num_int;i++))
		do
			echo "running Bench-INT $i : ${bench_int[$i]}"
			echo "*** input test-1"
			bash ${shell_name} ${bench_int[$i]} 0 $3 $4
			echo ""
		done
	elif [ "$2" = "ref" ]; then
		echo "run spec2006 for all benchmark with all ref inputs!"
		for((i=0;i<$num_int;i++))
		do
			echo "running Bench-INT $i : ${bench_int[$i]}"
			for((j=1;j<${number_int[$i]};j++))
			do
				echo "*** input ref-$j"
				bash ${shell_name} ${bench_int[$i]} $j $3 $4
			done
			echo ""
		done
	else
		echo "run spec2006 for all benchmark with input-$2 !"
		for((i=0;i<$num_int;i++))
		do
			echo "running Bench-INT $i : ${bench_int[$i]}"
			echo "*** input-$2"
			bash ${shell_name} ${bench_int[$i]} $2 $3 $4
			echo ""
		done
	fi
elif [ "$1" = "fp" ]; then
	if [ "$2" = "all" ]; then
		echo "run spec2006 for all benchmark with all inputs!"
		for((i=0;i<$num_fp;i++))
		do
			echo "running Bench-FP $i : ${bench_fp[$i]}"
			for((j=0;j<${number_fp[$i]};j++))
			do
				bash ${shell_name} ${bench_fp[$i]} $j $3 $4
			done
			echo ""
		done
	elif [ "$2" = "test" ]; then
		echo "run spec2006 for all benchmark with test input !"
		for((i=0;i<$num_fp;i++))
		do
			echo "running Bench-FP $i : ${bench_fp[$i]}"
			echo "*** input test-1"
			bash ${shell_name} ${bench_fp[$i]} 0 $3 $4
			echo ""
		done
	elif [ "$2" = "ref" ]; then
		echo "run spec2006 for all benchmark with all ref inputs!"
		for((i=0;i<$num_fp;i++))
		do
			echo "running Bench-FP $i : ${bench_fp[$i]}"
			for((j=1;j<${number_fp[$i]};j++))
			do
				echo "*** input ref-$j"
				bash ${shell_name} ${bench_fp[$i]} $j $3 $4
			done
			echo ""
		done
	else
		echo "run spec2006 for all benchmark with input-$2 !"
		for((i=0;i<$num_fp;i++))
		do
			echo "running Bench-FP $i : ${bench_fp[$i]}"
			echo "*** input-$2"
			bash ${shell_name} ${bench_fp[$i]} $2 $3 $4
			echo ""
		done
	fi
else
	find_number $1
	num=$?
	if [ $num -eq -1 ]; then
		echo "./run_spec.sh int/fp/all/400 test/ref/all/(0,1,2...)"
		exit
	fi
	
	if [ "$2" = "all" ]; then
		echo "run spec2006 for $1 with all inputs!"
		for((j=0;j<$num;j++))
		do
			echo "*** input input-$j"
			bash ${shell_name} $1 $j $3 $4
		done
		echo ""
	elif [ "$2" = "test" ]; then
		echo "run spec2006 for $1 with test input !"
		bash ${shell_name} $1 0 $3 $4
	elif [ "$2" = "ref" ]; then
		echo "run spec2006 for $1 with all ref inputs!"
		for((j=1;j<$num;j++))
		do
			echo "*** input ref-$j"
			bash ${shell_name} $1 $j $3 $4
		done
		echo ""
	else
		echo "run spec2006 for $1 with input-$2 !"
		bash ${shell_name} $1 $2 $3 $4
	fi
	
fi
