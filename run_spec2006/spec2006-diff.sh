#!/bin/bash
#判断输入是否合法
ARGC=$# 
if [[ "$ARGC" < 3 ]]
then
	echo "./run_spec2006.sh 400.perlbench(400, perlbench) number(test=0, ref=1,2,3,4...) ISA(arm,riscv,mips,alpha,x86) [diff]"
    exit
fi


# ************************** spec 2006 parameters ******************************
#arm riscv mips alpha amd64
if [ $3 = "arm" -o $3 = "ARM" ]; then
	ISA="arm"
	gem5_arch=ARM/gem5.opt
elif [ $3 = "riscv" -o $3 = "RISCV" ]; then
	ISA="riscv"
	gem5_arch=RISCV/gem5.opt
elif [ $3 = "mips" -o $3 = "MIPS" ]; then
	ISA="mips"
	gem5_arch=MIPS/gem5.opt
elif [ $3 = "alpha" -o $3 = "ALPHA" ]; then
	ISA="alpha"
	gem5_arch=ALPHA/gem5.opt
else
	ISA="amd64"
	gem5_arch=X86/gem5.opt	
fi
	
exe_suffix=""
exe_prefix="build_peak_${ISA}.0001"
exe_dir=run_base_ref_amd64.0001

spec_dir=/home/cuihongwei/experiment/mcpat-gem5-master/spec2006
# ****************************** gem5 parameters  ******************************
gem5_dir=/home/cuihongwei/experiment/experiment-gem5/raw-gem5
gem5_config=configs/example/se.py
gem5_DebugFlag=""
gem5_args="--num-cpus=1 --mem-size=8GB \
		   --l1d_assoc=8 --l2_assoc=16 --l1i_assoc=4 \
	       --cpu-type=DerivO3CPU --caches --l2cache "

#**************************** benchmark name ************************************
if [ $1 = "400" -o $1 = "perlbench" -o $1 = "400.perlbench" ]; then
	target="400.perlbench"
elif  [ $1 = "401" -o $1 = "bzip2" -o $1 = "401.bzip2" ]; then
	target="401.bzip2"
elif  [ $1 = "403" -o $1 = "gcc" -o $1 = "403.gcc" ]; then
	target="403.gcc"
elif  [ $1 = "410" -o $1 = "bwaves" -o $1 = "410.bwaves" ]; then
	target="410.bwaves"
elif  [ $1 = "416" -o $1 = "gamess" -o $1 = "416.gamess" ]; then
	target="416.gamess"
elif  [ $1 = "429" -o $1 = "mcf" -o $1 = "429.mcf" ]; then
	target="429.mcf"
elif  [ $1 = "433" -o $1 = "milc" -o $1 = "433.milc" ]; then
	target="433.milc"
elif  [ $1 = "434" -o $1 = "zeusmp" -o $1 = "434.zeusmp" ]; then
	target="434.zeusmp"
elif  [ $1 = "435" -o $1 = "gromacs" -o $1 = "435.gromacs" ]; then
	target="435.gromacs"
elif  [ $1 = "436" -o $1 = "cactusADM" -o $1 = "436.cactusADM" ]; then
	target="436.cactusADM"
elif  [ $1 = "437" -o $1 = "leslie3d" -o $1 = "437.leslie3d" ]; then
	target="437.leslie3d"
elif  [ $1 = "444" -o $1 = "namd" -o $1 = "444.namd" ]; then
	target="444.namd"
elif  [ $1 = "445." -o $1 = "gobmk" -o $1 = "445.gobmk" ]; then
	target="445.gobmk"
elif  [ $1 = "447" -o $1 = "dealII" -o $1 = "447.dealII" ]; then
	target="447.dealII"
elif  [ $1 = "450" -o $1 = "soplex" -o $1 = "450.soplex" ]; then
	target="450.soplex"
elif  [ $1 = "453" -o $1 = "povray" -o $1 = "453.povray" ]; then
	target="453.povray"
elif  [ $1 = "454" -o $1 = "calculix" -o $1 = "454.calculix" ]; then
	target="454.calculix"
elif  [ $1 = "456" -o $1 = "hmmer" -o $1 = "456.hmmer" ]; then
	target="456.hmmer"
elif  [ $1 = "458" -o $1 = "sjeng" -o $1 = "458.sjeng" ]; then
	target="458.sjeng"
elif  [ $1 = "459" -o $1 = "GemsFDTD" -o $1 = "459.GemsFDTD" ]; then
	target="459.GemsFDTD"
elif  [ $1 = "462" -o $1 = "libquantum" -o $1 = "462.libquantum" ]; then
	target="462.libquantum"
elif  [ $1 = "464" -o $1 = "h264ref" -o $1 = "464.h264ref" ]; then
	target="464.h264ref"
elif  [ $1 = "465" -o $1 = "tonto" -o $1 = "465.tonto" ]; then
	target="465.tonto"
elif  [ $1 = "470" -o $1 = "lbm" -o $1 = "470.lbm" ]; then
	target="470.lbm"
elif  [ $1 = "471" -o $1 = "omnetpp" -o $1 = "471.omnetpp" ]; then
	target="471.omnetpp"
elif  [ $1 = "473" -o $1 = "astar" -o $1 = "473.astar" ]; then
	target="473.astar"
elif  [ $1 = "481" -o $1 = "wrf" -o $1 = "481.wrf" ]; then
	target="481.wrf"
elif  [ $1 = "482" -o $1 = "sphinx3" -o $1 = "482.sphinx3" ]; then
	target="482.sphinx3"
elif  [ $1 = "483" -o $1 = "xalancbmk" -o $1 = "483.xalancbmk" ]; then
	target="483.xalancbmk"
elif  [ $1 = "999" -o $1 = "specrand" -o $1 = "999.specrand" ]; then
	target="999.specrand"
else
	echo "input wrong!"
	exit
fi


#******************************** necessary directory *****************

#运行目录，具体到可以支持benchmark可以运行的目录
run_dir=$spec_dir/benchspec/CPU2006/$target/run/$exe_dir

curTime=$(date "+%y%m%d-%H%M%S")
#Gem5的输出文件目录，包括stats的输出文件等
gem5_output_dir=$gem5_dir/output/$ISA-$target-"input"$2-$curTime
#benchmark的输出目录
benchmark_output=$gem5_output_dir
#记录执行参数的脚本
mkdir -p $gem5_output_dir
script_out=$gem5_output_dir/runscript.log

#*********************** spec2006 cmd *********************
# --cmd
# without running directory
cmd_perlbench="perlbench"$exe_suffix
cmd_bzip2="bzip2"$exe_suffix
cmd_gcc="gcc"$exe_suffix
cmd_bwaves="bwaves"$exe_suffix
cmd_gamess="gamess"$exe_suffix
cmd_mcf="mcf"$exe_suffix
cmd_milc="milc"$exe_suffix
cmd_zeusmp="zeusmp"$exe_suffix
cmd_gromacs="gromacs"$exe_suffix
cmd_cactusADM="cactusADM"$exe_suffix
cmd_leslie3d="leslie3d"$exe_suffix
cmd_namd="namd"$exe_suffix
cmd_gobmk="gobmk"$exe_suffix
cmd_dealII="dealII"$exe_suffix
cmd_soplex="soplex"$exe_suffix
cmd_povray="povray"$exe_suffix
cmd_calculix="calculix"$exe_suffix
cmd_hmmer="hmmer"$exe_suffix
cmd_sjeng="sjeng"$exe_suffix
cmd_GemsFDTD="GemsFDTD"$exe_suffix
cmd_libquantum="libquantum"$exe_suffix
cmd_h264ref="h264ref"$exe_suffix
cmd_tonto="tonto"$exe_suffix
cmd_lbm="lbm"$exe_suffix
cmd_omnetpp="omnetpp"$exe_suffix
cmd_astar="astar"$exe_suffix
cmd_wrf="wrf"$exe_suffix
cmd_sphinx3="sphinx3"$exe_suffix
cmd_xalancbmk="Xalan"$exe_suffix
#.....
cmd_specrand="specrand"$exe_suffix


#************************ benchmark parameters ****************
# --options
#test
args_perlbench[0]="-I. -I./lib attrs.pl"
#ref
args_perlbench[1]="-I./lib checkspam.pl 2500 5 25 11 150 1 1 1 1"
args_perlbench[2]="-I./lib diffmail.pl 4 800 10 17 19 300"
args_perlbench[3]="-I./lib splitmail.pl 1600 12 26 16 4500"
name_perlbench[3]="splitmail.1600.12.26.16.4500"
name_perlbench[2]="diffmail.4.800.10.17.19.300"
name_perlbench[1]="checkspam.2500.5.25.11.150.1.1.1.1"
name_perlbench[0]="attrs"
num_perlbench=4

args_bzip2[0]="input.program 5"
args_bzip2[1]="input.source 280"
args_bzip2[2]="chicken.jpg 30"
args_bzip2[3]="liberty.jpg 30"
args_bzip2[4]="input.program 280"
args_bzip2[5]="text.html 280"
args_bzip2[6]="input.combined 200"
name_bzip2[2]="chicken.jpg"
name_bzip2[5]="text.html"
name_bzip2[4]="input.program"
name_bzip2[1]="input.source"
name_bzip2[3]="liberty.jpg"
name_bzip2[6]="input.combined"
name_bzip2[0]="input.program"
num_bzip2=7

args_gcc[0]="cccp.i -o cccp.s"
args_gcc[1]="166.i -o 166.s"
args_gcc[2]="200.i -o 200.s"
args_gcc[3]="c-typeck.i -o c-typeck.s"
args_gcc[4]="cp-decl.i -o cp-decl.s"
args_gcc[5]="expr.i -o expr.s"
args_gcc[6]="expr2.i -o expr2.s"
args_gcc[7]="g23.i -o g23.s"
args_gcc[8]="s04.i -o s04.s"
args_gcc[9]="scilab.i -o scilab.s"
name_gcc[4]="cp-decl"
name_gcc[6]="expr2"
name_gcc[1]="166"
name_gcc[3]="c-typeck"
name_gcc[9]="scilab"
name_gcc[5]="expr"
name_gcc[7]="g23"
name_gcc[2]="200"
name_gcc[8]="s04"
name_gcc[0]="cccp"
num_gcc=10

args_bwaves[0]=""
args_bwaves[1]=""
name_bwaves[1]="bwaves"
name_bwaves[0]="bwaves"
num_bwaves=2

args_gamess[0]=""
args_gamess[1]=""
args_gamess[2]=""
args_gamess[3]=""
name_gamess[1]="cytosine.2"
name_gamess[3]="triazolium"
name_gamess[2]="h2ocu2+.gradient"
name_gamess[0]="exam29"
num_gamess=4

args_mcf[0]="inp.in"
args_mcf[1]="inp.in"
name_mcf[0]="inp"
name_mcf[1]="inp"
num_mcf=2

args_milc[0]=""
args_milc[1]=""
name_milc[1]="su3imp"
name_milc[0]="su3imp"
num_milc=2

#sdtout err
args_zeusmp[0]=""
args_zeusmp[1]=""
name_zeusmp[1]="zeusmp"
name_zeusmp[0]="zeusmp"
num_zeusmp=2

args_gromacs[0]="-silent -deffnm gromacs -nice 0"
args_gromacs[1]="-silent -deffnm gromacs -nice 0"
name_gromacs[1]="gromacs"
name_gromacs[0]="gromacs"
num_gromacs=2

args_cactusADM[0]="benchADM.par"
args_cactusADM[1]="benchADM.par"
name_cactusADM[1]="benchADM"
name_cactusADM[0]="benchADM"
num_cactusADM=2

#stdout err
args_leslie3d[0]="leslie3d.in"
args_leslie3d[1]="leslie3d.in"
name_leslie3d[1]="leslie3d"
name_leslie3d[0]="leslie3d"
num_leslie3d=2

#stdout err
args_namd[0]="--input namd.input --output namd.out --iterations 1"
args_namd[1]="--input namd.input --output namd.out --iterations 38"
name_namd[1]="namd"
name_namd[0]="namd"
num_namd=2

args_gobmk[0]="--quiet --mode gtp"
args_gobmk[1]="--quiet --mode gtp"
args_gobmk[2]="--quiet --mode gtp"
args_gobmk[3]="--quiet --mode gtp"
args_gobmk[4]="--quiet --mode gtp"
args_gobmk[5]="--quiet --mode gtp"
name_gobmk[5]="trevord"
name_gobmk[4]="trevorc"
name_gobmk[1]="13x13"
name_gobmk[3]="score2"
name_gobmk[2]="nngs"
name_gobmk[0]="dniwog"
num_gobmk=6


#log err
args_dealII[0]="8"
args_dealII[1]="23"
name_dealII[1]="dealII"
name_dealII[0]="dealII"
num_dealII=2

#out stderr
args_soplex[0]="-m10000 test.mps"
args_soplex[1]="-s1 -e -m45000 pds-50.mps"
args_soplex[2]="-m3500 ref.mps"
name_soplex[2]="ref"
name_soplex[1]="pds-50.mps"
name_soplex[0]="test"
num_soplex=3


#stdout stderr
args_povray[0]="SPEC-benchmark-test.ini"
args_povray[1]="SPEC-benchmark-ref.ini"
name_povray[1]="SPEC-benchmark-ref"
name_povray[0]="SPEC-benchmark-test"
num_povray=2

args_calculix[0]="-i beampic"
args_calculix[1]="-i hyperviscoplastic"
name_calculix[1]="hyperviscoplastic"
name_calculix[0]="beampic"
num_calculix=2

args_hmmer[0]="--fixed 0 --mean 325 --num 45000 --sd 200 --seed 0 bombesin.hmm"
args_hmmer[1]="nph3.hmm swiss41"
args_hmmer[2]="--fixed 0 --mean 500 --num 500000 --sd 350 --seed 0 retro.hmm"
name_hmmer[1]="nph3"
name_hmmer[2]="retro"
name_hmmer[0]="bombesin"
num_hmmer=3

args_sjeng[0]="test.txt"
args_sjeng[1]="ref.txt"
name_sjeng[1]="ref"
name_sjeng[0]="test"
num_sjeng=2

args_GemsFDTD[0]=""
args_GemsFDTD[1]=""
#log
name_GemsFDTD[1]="ref"
name_GemsFDTD[0]="test"
num_GemsFDTD=2

args_libquantum[0]="33 5"
args_libquantum[1]="1397 8"
name_libquantum[1]="ref"
name_libquantum[0]="test"
num_libquantum=2

args_h264ref[0]="-d foreman_test_encoder_baseline.cfg"
args_h264ref[1]="-d foreman_ref_encoder_baseline.cfg"
args_h264ref[2]="-d foreman_ref_encoder_main.cfg"
args_h264ref[3]="-d sss_encoder_main.cfg"
name_h264ref[1]="foreman_ref_baseline_encodelog"
name_h264ref[3]="sss_main_encodelog"
name_h264ref[2]="foreman_ref_main_encodelog"
name_h264ref[0]="foreman_test_baseline_encodelog"
num_h264ref=4

args_tonto[0]=""
args_tonto[1]=""
name_tonto[0]="test"
name_tonto[1]="ref"
num_tonto=2

args_lbm[0]="20 reference.dat 0 1 100_100_130_cf_a.of"
args_lbm[1]="300 reference.dat 0 0 100_100_130_ldc.of"
name_lbm[1]="lbm"
name_lbm[0]="lbm"
num_lbm=2

#log err
args_omnetpp[0]="omnetpp.ini"
args_omnetpp[1]="omnetpp.ini"
name_omnetpp[0]="omnetpp"
name_omnetpp[1]="omnetpp"
num_omnetpp=2

args_astar[0]="lake.cfg"
args_astar[1]="rivers.cfg"
args_astar[2]="BigLakes2048.cfg"
name_astar[1]="rivers"
name_astar[2]="BigLakes2048"
name_astar[0]="lake"
num_astar=3

args_wrf[0]=""
args_wrf[1]=""
name_wrf[1]="wrf"
name_wrf[0]="wrf"
num_wrf=2

#log err
args_sphinx3[0]="ctlfile . args.an4"
args_sphinx3[1]="ctlfile . args.an4"
name_sphinx3[0]="an4"
name_sphinx3[1]="an4"
num_sphinx3=2

args_xalancbmk[0]="-v test.xml xalanc.xsl"
args_xalancbmk[1]="-v t5.xml xalanc.xsl"
name_xalancbmk[1]="ref"
name_xalancbmk[0]="test"
num_xalancbmk=2


args_specrand[0]="324342 24239"
args_specrand[1]="1255432124 234923"
name_specrand[0]="rand.24239"
name_specrand[1]="rand.234923"
num_specrand=2


#************************ benchmark input ****************
input_perlbench=""
input_bzip2=""
input_gcc=""
input_bwaves=""
input_gamess[0]="exam29.config"
input_gamess[1]="cytosine.2.config"
input_gamess[2]="h2ocu2+.gradient.config"
input_gamess[3]="triazolium.config"
input_mcf=""
input_milc[0]="su3imp.in"
input_milc[1]="su3imp.in"
input_zeusmp=""
input_gromacs=""
input_cactusADM=""
input_leslie3d[0]="leslie3d.in"
input_leslie3d[1]="leslie3d.in"
input_namd=""
input_gobmk[0]="dniwog.tst"
input_gobmk[1]="13x13.tst"
input_gobmk[2]="nngs.tst"
input_gobmk[3]="score2.tst"
input_gobmk[4]="trevorc.tst"
input_gobmk[5]="trevord.tst"
input_dealII=""
input_soplex=""
input_povray=""
input_calculix=""
input_hmmer=""
input_sjeng=""
input_GemsFDTD=""
input_libquantum=""
input_h264ref=""
input_tonto=""
input_lbm=""
input_omnetpp=""
input_astar=""
input_wrf=""
input_sphinx3=""
input_xalancbmk=""
input_specrand=""


#****************************** choose benchmark ******************************
if [ $target = "400.perlbench" ]; 	then
	cmd=$cmd_perlbench
	if [ $2 -lt $num_perlbench ]; then
		args=${args_perlbench[$2]}
		input=$input_perlbench
		output=${name_perlbench[$2]}".out"
		errout=${name_perlbench[$2]}".err"
	else
		echo "$2 is too big"
		exit
	fi
	
elif  [ $target = "401.bzip2" ]; 	then
	cmd=$cmd_bzip2
	if [ $2 -lt $num_bzip2 ]; then
		args=${args_bzip2[$2]}
		input=$input_bzip2
		output=${name_bzip2[$2]}".out"
		errout=${name_bzip2[$2]}".err"
	else
		echo "$2 is too big"
		exit
	fi
	
elif  [ $target = "403.gcc" ]; 		then
	cmd=$cmd_gcc
	if [ $2 -lt $num_gcc ]; then
		args=${args_gcc[$2]}
		input=$input_gcc
		output=${name_gcc[$2]}".out"
		errout=${name_gcc[$2]}".err"
	else
		echo "$2 is too big"
		exit
	fi
	
elif  [ $target = "410.bwaves" ]; 	then
	cmd=$cmd_bwaves
	if [ $2 -lt $num_bwaves ]; then
		args=${args_bwaves[$2]}
		input=$input_bwaves
		output=${name_bwaves[$2]}".out"
		errout=${name_bwaves[$2]}".err"
	else
		echo "$2 is too big"
		exit
	fi
	
elif  [ $target = "416.gamess" ]; 	then
	cmd=$cmd_gamess
	if [ $2 -lt $num_gamess ]; then
		args=${args_gamess[$2]}
		input=${input_gamess[$2]}
		output=${name_gamess[$2]}".out"
		errout=${name_gamess[$2]}".err"
	else
		echo "$2 is too big"
		exit
	fi
	
elif  [ $target = "429.mcf" ]; 		then
	cmd=$cmd_mcf
	if [ $2 -lt $num_mcf ]; then
		args=${args_mcf[$2]}
		input=$input_mcf
		output=${name_mcf[$2]}".out"
		errout=${name_mcf[$2]}".err"
	else
		echo "$2 is too big"
		exit
	fi
	
elif  [ $target = "433.milc" ]; 	then
	cmd=$cmd_milc
	if [ $2 -lt $num_milc ]; then
		args=${args_milc[$2]}
		input=${input_milc[$2]}
		output=${name_milc[$2]}".out"
		errout=${name_milc[$2]}".err"
	else
		echo "$2 is too big"
		exit
	fi
	
elif  [ $target = "434.zeusmp" ]; 	then
	cmd=$cmd_zeusmp
	if [ $2 -lt $num_zeusmp ]; then
		args=${args_zeusmp[$2]}
		input=$input_zeusmp
		output=${name_zeusmp[$2]}".stdout"
		errout=${name_zeusmp[$2]}".err"
	else
		echo "$2 is too big"
		exit
	fi

elif  [ $target = "435.gromacs" ]; 	then
	cmd=$cmd_gromacs
	if [ $2 -lt $num_gromacs ]; then
		args=${args_gromacs[$2]}
		input=$input_gromacs
		output=${name_gromacs[$2]}".out"
		errout=${name_gromacs[$2]}".err"
	else
		echo "$2 is too big"
		exit
	fi

elif  [ $target = "436.cactusADM" ]; then
	cmd=$cmd_cactusADM
	if [ $2 -lt $num_cactusADM ]; then
		args=${args_cactusADM[$2]}
		input=$input_cactusADM
		output=${name_cactusADM[$2]}".out"
		errout=${name_cactusADM[$2]}".err"
	else
		echo "$2 is too big"
		exit
	fi
	
elif  [ $target = "437.leslie3d" ]; then
	cmd=$cmd_leslie3d
	if [ $2 -lt $num_leslie3d ]; then
		args=${args_leslie3d[$2]}
		input=${input_leslie3d[$2]}
		output=${name_leslie3d[$2]}".stdout"
		errout=${name_leslie3d[$2]}".err"
	else
		echo "$2 is too big"
		exit
	fi
	
elif  [ $target = "444.namd" ]; 	then
	cmd=$cmd_namd
	if [ $2 -lt $num_namd ]; then
		args=${args_namd[$2]}
		input=$input_namd
		output=${name_namd[$2]}".stdout"
		errout=${name_namd[$2]}".err"
	else
		echo "$2 is too big"
		exit
	fi
	
elif  [ $target = "445.gobmk" ]; 	then
	cmd=$cmd_gobmk
	if [ $2 -lt $num_gobmk ]; then
		args=${args_gobmk[$2]}
		input=${input_gobmk[$2]}
		output=${name_gobmk[$2]}".out"
		errout=${name_gobmk[$2]}".err"
	else
		echo "$2 is too big"
		exit
	fi
	
elif  [ $target = "447.dealII" ]; 	then
	cmd=$cmd_dealII
	if [ $2 -lt $num_dealII ]; then
		args=${args_dealII[$2]}
		input=$input_dealII
		output="log"
		errout=${name_dealII[$2]}".err"
	else
		echo "$2 is too big"
		exit
	fi
	
elif  [ $target = "450.soplex" ]; 	then
	cmd=$cmd_soplex
	if [ $2 -lt $num_soplex ]; then
		args=${args_soplex[$2]}
		input=$input_soplex
		output=${name_soplex[$2]}".out"
		errout=${name_soplex[$2]}".stderr"
	else
		echo "$2 is too big"
		exit
	fi
	
elif  [ $target = "453.povray" ]; 	then
	cmd=$cmd_povray
	if [ $2 -lt $num_povray ]; then
		args=${args_povray[$2]}
		input=$input_povray
		output=${name_povray[$2]}".stdout"
		errout=${name_povray[$2]}".stderr"
	else
		echo "$2 is too big"
		exit
	fi
	
elif  [ $target = "454.calculix" ]; then
	cmd=$cmd_calculix
	if [ $2 -lt $num_calculix ]; then
		args=${args_calculix[$2]}
		input=$input_calculix
		output=${name_calculix[$2]}".out"
		errout=${name_calculix[$2]}".err"
	else
		echo "$2 is too big"
		exit
	fi
	
elif  [ $target = "456.hmmer" ]; 	then
	cmd=$cmd_hmmer
	if [ $2 -lt $num_hmmer ]; then
		args=${args_hmmer[$2]}
		input=$input_hmmer
		output=${name_hmmer[$2]}".out"
		errout=${name_hmmer[$2]}".err"
	else
		echo "$2 is too big"
		exit
	fi
	
elif  [ $target = "458.sjeng" ]; 	then
	cmd=$cmd_sjeng
	if [ $2 -lt $num_sjeng ]; then
		args=${args_sjeng[$2]}
		input=$input_sjeng
		output=${name_sjeng[$2]}".out"
		errout=${name_sjeng[$2]}".err"
	else
		echo "$2 is too big"
		exit
	fi
	
elif  [ $target = "459.GemsFDTD" ]; then
	cmd=$cmd_GemsFDTD
	if [ $2 -lt $num_GemsFDTD ]; then
		args=${args_GemsFDTD[$2]}
		input=$input_GemsFDTD
		output=${name_GemsFDTD[$2]}".log"
		errout=${name_GemsFDTD[$2]}".err"
	else
		echo "$2 is too big"
		exit
	fi
	
elif  [ $target = "462.libquantum" ]; then
	cmd=$cmd_libquantum
	if [ $2 -lt $num_libquantum ]; then
		args=${args_libquantum[$2]}
		input=$input_libquantum
		output=${name_libquantum[$2]}".out"
		errout=${name_libquantum[$2]}".err"
	else
		echo "$2 is too big"
		exit
	fi
	
elif  [ $target = "464.h264ref" ]; 	then
	cmd=$cmd_h264ref
	if [ $2 -lt $num_h264ref ]; then
		args=${args_h264ref[$2]}
		input=$input_h264ref
		output=${name_h264ref[$2]}".out"
		errout=${name_h264ref[$2]}".err"
	else
		echo "$2 is too big"
		exit
	fi
	
elif  [ $target = "465.tonto" ]; 	then
	cmd=$cmd_tonto
	if [ $2 -lt $num_tonto ]; then
		args=${args_tonto[$2]}
		input=$input_tonto
		output=${name_tonto[$2]}".out"
		errout=${name_tonto[$2]}".err"
	else
		echo "$2 is too big"
		exit
	fi
	
elif  [ $target = "470.lbm" ]; 		then
	cmd=$cmd_lbm
	if [ $2 -lt $num_lbm ]; then
		args=${args_lbm[$2]}
		input=$input_lbm
		output=${name_lbm[$2]}".out"
		errout=${name_lbm[$2]}".err"
	else
		echo "$2 is too big"
		exit
	fi
	
elif  [ $target = "471.omnetpp" ]; 	then
	cmd=$cmd_omnetpp
	if [ $2 -lt $num_omnetpp ]; then
		args=${args_omnetpp[$2]}
		input=$input_omnetpp
		output=${name_omnetpp[$2]}".log"
		errout=${name_omnetpp[$2]}".err"
	else
		echo "$2 is too big"
		exit
	fi
	
elif  [ $target = "473.astar" ];	then
	cmd=$cmd_astar
	if [ $2 -lt $num_astar ]; then
		args=${args_astar[$2]}
		input=$input_astar
		output=${name_astar[$2]}".out"
		errout=${name_astar[$2]}".err"
	else
		echo "$2 is too big"
		exit
	fi
	
elif  [ $target = "481.wrf" ]; 		then
	cmd=$cmd_wrf
	if [ $2 -lt $num_wrf ]; then
		args=${args_wrf[$2]}
		input=$input_wrf
		output="rsl.out.0000"
		errout=${name_wrf[$2]}".err"
	else
		echo "$2 is too big"
		exit
	fi
	
elif  [ $target = "482.sphinx3" ]; 	then
	cmd=$cmd_sphinx3
	if [ $2 -lt $num_sphinx3 ]; then
		args=${args_sphinx3[$2]}
		input=$input_sphinx3
		output=${name_sphinx3[$2]}".log"
		errout=${name_sphinx3[$2]}".err"
	else
		echo "$2 is too big"
		exit
	fi
	
elif  [ $target = "483.xalancbmk" ]; then
	cmd=$cmd_xalancbmk
	if [ $2 -lt $num_xalancbmk ]; then
		args=${args_xalancbmk[$2]}
		input=$input_xalancbmk
		output=${name_xalancbmk[$2]}".out"
		errout=${name_xalancbmk[$2]}".err"
	else
		echo "$2 is too big"
		exit
	fi
	
elif  [ $target = "999.specrand" ]; then
	cmd=$cmd_specrand
	if [ $2 -lt $num_specrand ]; then
		args=${args_specrand[$2]}
		input=$input_specrand
		output=${name_specrand[$2]}".out"
		errout=${name_specrand[$2]}".err"
	else
		echo "$2 is too big"
		exit
	fi
	
else
	echo "input wrong!"
	exit
fi
#*******************************start execution************************

echo "" | tee $script_out
echo "******************************directory****************************" | tee -a $script_out
echo "spec_dir: "$spec_dir | tee -a $script_out
echo "run_dir:  "$run_dir | tee -a $script_out
echo "gem5_dir: "$gem5_dir | tee -a $script_out
echo "gem5_output_dir: "$gem5_output_dir | tee -a $script_out
echo "benchmark_output:"$gem5_output_dir | tee -a $script_out
echo "" | tee -a $script_out

echo "******************************benchmark****************************" | tee -a $script_out
echo "target:     "$target | tee -a $script_out
echo "executable: "$cmd | tee -a $script_out
echo "args:       "$args | tee -a $script_out
echo "input:      "$input | tee -a $script_out
echo "output:     "${benchmark_output}/$output | tee -a $script_out
echo "errout:     "${benchmark_output}/$errout | tee -a $script_out
echo "" | tee -a $script_out

echo "******************************gem5****************************" | tee -a $script_out
echo "arch:       "$gem5_dir/build/$gem5_arch | tee -a $script_out
echo "config:     "$gem5_dir/$gem5_config | tee -a $script_out
echo "args:       "$gem5_args | tee -a $script_out
echo "" | tee -a $script_out


echo "******************************simulation****************************" | tee -a $script_out
echo "start time:(year-mon-day hour-minute-second)"$(date "+%y-%m-%d %H-%M-%S")| tee -a $script_out


#进入工作目录
cd $run_dir

exe_prefix=$spec_dir/benchspec/CPU2006/$target/run/$exe_prefix

#************************************ run gem5 **************************************/
$gem5_dir/build/$gem5_arch $gem5_DebugFlag\
	--outdir=$gem5_output_dir  \
	$gem5_dir/$gem5_config $gem5_args \
	--cmd=$exe_prefix/$cmd --options="$args" \
	--output=${benchmark_output}/$output --input=$input \
	--errout=${benchmark_output}/$errout | tee -a $script_out
	
echo "end time:(year-mon-day hour-minute-second)"$(date "+%y-%m-%d %H-%M-%S") | tee -a $script_out



#*********************************** specdiff ***************************
#if [ "$4" != "diff" ]; then
#	exit
#fi

specdiff_log=$gem5_output_dir/"${target}_input$2_specdiff.sh"
spec_out=$spec_dir/benchspec/CPU2006/$target/data/test/output
if [ $2 -ne 0 ]; then
	spec_out=$spec_dir/benchspec/CPU2006/$target/date/ref/output
fi

echo "specdiff:    $specdiff"|tee -a $script_out
echo "specdiff_log:    $specdiff_log"|tee -a $script_out

echo "script: ${target}_input$2_specdiff.sh"
echo "#!/bin/bash" | tee -a $specdiff_log
#echo "echo \"please use source specdiff.sh to run this script\"" | tee -a  $specdiff_log
echo "cd $spec_dir"  | tee -a  $specdiff_log
echo "source shrc" | tee -a  $specdiff_log
#echo "cd -" | tee -a  $specdiff_log

if [ $target = "400.perlbench" ]; 	then
	echo "#specdiff $target input-$2 " | tee -a $specdiff_log
	echo "specdiff -m -l 10 ${spec_out}/$output ${benchmark_output}/$output"  | tee -a $specdiff_log
	#specdiff -m -l 10 ${spec_out}/$output ${benchmark_output}/$output | tee -a $specdiff_log
	
elif  [ $target = "401.bzip2" ]; 	then
	echo "#specdiff $target input-$2 " | tee -a $specdiff_log
	echo "specdiff -m -l 10 ${spec_out}/$output ${benchmark_output}/$output"  | tee -a $specdiff_log
	#specdiff -m -l 10 ${spec_out}/$output ${benchmark_output}/$output | tee -a $specdiff_log
	
elif  [ $target = "403.gcc" ]; 		then
	echo "#specdiff $target input-$2 " | tee -a $specdiff_log
	echo "specdiff -m -l 10 ${spec_out}/${name_gcc[$2]}.s ${benchmark_output}/${name_gcc[$2]}.s"  | tee -a $specdiff_log
	#specdiff -m -l 10 ${spec_out}/${name_gcc[$2]}.s ${benchmark_output}/${name_gcc[$2]}.s
	
elif  [ $target = "410.bwaves" ]; 	then
	echo "#specdiff $target input-$2 " | tee -a $specdiff_log
	echo "specdiff -m -l 10  --abstol 1e-16 ${spec_out}/bwaves.out ${benchmark_output}/bwaves.out"  | tee -a $specdiff_log
	#specdiff -m -l 10  --abstol 1e-16 ${spec_out}/bwaves.out ${benchmark_output}/bwaves.out | tee -a $specdiff_log
	echo "specdiff -m -l 10  --reltol 0.015 ${spec_out}/bwaves2.out ${benchmark_output}/bwaves2.out"  | tee -a $specdiff_log
	#specdiff -m -l 10  --reltol 0.015 ${spec_out}/bwaves.out ${benchmark_output}/bwaves2.out | tee -a $specdiff_log
	echo "specdiff -m -l 10  --reltol 1e-06 ${spec_out}/bwaves3.out ${benchmark_output}/bwaves3.out"  | tee -a $specdiff_log
	#specdiff -m -l 10  --reltol 1e-06 ${spec_out}/bwaves.out ${benchmark_output}/bwaves3.out | tee -a $specdiff_log
	
elif  [ $target = "416.gamess" ]; 	then
	echo "#specdiff $target input-$2 " | tee -a $specdiff_log
	echo "specdiff -m -l 10  --abstol 1e-05  --reltol 0.0001  --ignorecase ${spec_out}/$output ${benchmark_output}/$output"  | tee -a $specdiff_log
	#specdiff -m -l 10  --abstol 1e-05  --reltol 0.0001  --ignorecase ${spec_out}/$output ${benchmark_output}/$output | tee -a $specdiff_log
	
elif  [ $target = "429.mcf" ]; 		then
	echo "#specdiff $target input-$2 " | tee -a $specdiff_log
	echo "specdiff -m -l 10 ${spec_out}/inp.out ${benchmark_output}/inp.out"  | tee -a $specdiff_log
	#specdiff -m -l 10 ${spec_out}/inp.out ${benchmark_output}/inp.out | tee -a $specdiff_log
	echo "specdiff -m -l 10 ${spec_out}/mcf.out ${benchmark_output}/mcf.out"  | tee -a $specdiff_log
	#specdiff -m -l 10 ${spec_out}/mcf.out ${benchmark_output}/mcf.out | tee -a $specdiff_log
	
elif  [ $target = "433.milc" ]; 	then
	echo "#specdiff $target input-$2 " | tee -a $specdiff_log
	echo "specdiff -m -l 10  --abstol 2e-07  --reltol 0.0001 ${spec_out}/$output ${benchmark_output}/$output"  | tee -a $specdiff_log
	#specdiff -m -l 10  --abstol 2e-07  --reltol 0.0001 ${spec_out}/$output ${benchmark_output}/$output | tee -a $specdiff_log
	
elif  [ $target = "434.zeusmp" ]; 	then
	echo "#specdiff $target input-$2 " | tee -a $specdiff_log
	echo "specdiff -m -l 10  --abstol 0.001  --reltol 0.001 ${spec_out}/tsl000aa ${benchmark_output}/tsl000aa"  | tee -a $specdiff_log
	#specdiff -m -l 10  --abstol 0.001  --reltol 0.001 ${spec_out}/tsl000aa${benchmark_output}/tsl000aa | tee -a $specdiff_log

elif  [ $target = "435.gromacs" ]; 	then
	echo "#specdiff $target input-$2 " | tee -a $specdiff_log
	echo "specdiff -m -l 10  --reltol 0.0125 ${spec_out}/$output ${benchmark_output}/$output"  | tee -a $specdiff_log
	#specdiff -m -l 10  --reltol 0.0125 ${spec_out}/$output ${benchmark_output}/$output | tee -a $specdiff_log

elif  [ $target = "436.cactusADM" ]; then
	echo "#specdiff $target input-$2 " | tee -a $specdiff_log
	echo "specdiff -m -l 10  --floatcompare ${spec_out}/$output ${benchmark_output}/$output"  | tee -a $specdiff_log
	#specdiff -m -l 10  --floatcompare ${spec_out}/$output ${benchmark_output}/$output | tee -a $specdiff_log
	
elif  [ $target = "437.leslie3d" ]; then
	echo "#specdiff $target input-$2 " | tee -a $specdiff_log
	echo "specdiff -m -l 10  --floatcompare ${spec_out}/$output ${benchmark_output}/$output"  | tee -a $specdiff_log
	#specdiff -m -l 10  --floatcompare ${spec_out}/$output ${benchmark_output}/$output | tee -a $specdiff_log
	
elif  [ $target = "444.namd" ]; 	then
	echo "#specdiff $target input-$2 " | tee -a $specdiff_log
	echo "specdiff -m -l 10  --abstol 1e-05 ${spec_out}/$output ${benchmark_output}/$output"  | tee -a $specdiff_log
	#specdiff -m -l 10  --abstol 1e-05 ${spec_out}/$output ${benchmark_output}/$output | tee -a $specdiff_log
	
elif  [ $target = "445.gobmk" ]; 	then
	echo "#specdiff $target input-$2 " | tee -a $specdiff_log
	echo "specdiff -m -l 10 ${spec_out}/$output ${benchmark_output}/$output"  | tee -a $specdiff_log
	#specdiff -m -l 10  ${spec_out}/$output ${benchmark_output}/$output | tee -a $specdiff_log
	
elif  [ $target = "447.dealII" ]; 	then
	echo "too much for compare" | tee -a $specdiff_log
	echo "#specdiff $target input-$2 " | tee -a $specdiff_log
	echo "specdiff -m -l 10 --abstol 1e-07 ${spec_out}/log ${benchmark_output}/log"  | tee -a $specdiff_log
	#specdiff -m -l 10 --abstol 1e-07 ${spec_out}/log ${benchmark_output}/log | tee -a $specdiff_log
	
elif  [ $target = "450.soplex" ]; 	then
	echo "#specdiff $target input-$2 " | tee -a $specdiff_log
	echo "specdiff -m -l 10 --abstol 1e-05  --reltol 0.02  --obiwan ${spec_out}/$output ${benchmark_output}/$output"  | tee -a $specdiff_log
	#specdiff -m -l 10 --abstol 1e-05  --reltol 0.02  --obiwan ${spec_out}/$output ${benchmark_output}/$output | tee -a $specdiff_log
	echo "specdiff -m -l 10 --abstol 20  --reltol 0.0001  --obiwan ${spec_out}/$errout ${benchmark_output}/$errout"  | tee -a $specdiff_log
	#specdiff -m -l 10 --abstol 20  --reltol 0.0001  --obiwan ${spec_out}/$errout ${benchmark_output}/$errout | tee -a $specdiff_log
	
elif  [ $target = "453.povray" ]; 	then
	echo "#specdiff $target input-$2 " | tee -a $specdiff_log
	echo "specdiff -m -l 10 --abstol 0  --reltol 5e-05 ${spec_out}/SPEC-benchmark.log ${benchmark_output}/SPEC-benchmark.log"  | tee -a $specdiff_log
	#specdiff -m -l 10 --abstol 0  --reltol 5e-05 ${spec_out}/SPEC-benchmark.log ${benchmark_output}/SPEC-benchmark.log | tee -a $specdiff_log
	echo "specdiff -m -l 10 --abstol 0  --reltol 5e-05  --skiptol 50  --binary  ${spec_out}/SPEC-benchmark.tga ${benchmark_output}/SPEC-benchmark.tga"  | tee -a $specdiff_log
	#specdiff -m -l 10 --abstol 0  --reltol 5e-05  --skiptol 50  --binary  ${spec_out}/SPEC-benchmark.tga ${benchmark_output}/SPEC-benchmark.tga | tee -a $specdiff_log
	
elif  [ $target = "454.calculix" ]; then
	echo "#specdiff $target input-$2 " | tee -a $specdiff_log
	echo "specdiff -m -l 10 --abstol 1e-09  --reltol 1e-09  --obiwan  ${spec_out}/SPECtestformatmodifier_z.txt ${benchmark_output}/SPECtestformatmodifier_z.txt"  | tee -a $specdiff_log
	#specdiff -m -l 10 --abstol 1e-09  --reltol 1e-09  --obiwan  ${spec_out}/SPECtestformatmodifier_z.txt ${benchmark_output}/SPECtestformatmodifier_z.txt | tee -a $specdiff_log
	echo "specdiff -m -l 10 --abstol 1e-09  --reltol 1e-09  --obiwan  ${spec_out}/hyperviscoplastic.dat ${benchmark_output}/hyperviscoplastic.dat"  | tee -a $specdiff_log
	#specdiff -m -l 10 --abstol 1e-09  --reltol 1e-09  --obiwan  ${spec_out}/hyperviscoplastic.dat ${benchmark_output}/hyperviscoplastic.dat | tee -a $specdiff_log
	
elif  [ $target = "456.hmmer" ]; 	then
	echo "#specdiff $target input-$2 " | tee -a $specdiff_log
	echo "specdiff -m -l 10 --abstol 1e-05  --reltol 0.002  --skiptol 10 ${spec_out}/$output ${benchmark_output}/$output"  | tee -a $specdiff_log
	#specdiff -m -l 10 --abstol 1e-05  --reltol 0.002  --skiptol 10 ${spec_out}/$output ${benchmark_output}/$output | tee -a $specdiff_log
	
elif  [ $target = "458.sjeng" ]; 	then
	echo "#specdiff $target input-$2 " | tee -a $specdiff_log
	echo "specdiff -m -l 10 ${spec_out}/$output ${benchmark_output}/$output"  | tee -a $specdiff_log
	#specdiff -m -l 10  ${spec_out}/$output ${benchmark_output}/$output | tee -a $specdiff_log
	
elif  [ $target = "459.GemsFDTD" ]; then
	echo "#specdiff $target input-$2 " | tee -a $specdiff_log
	echo "specdiff -m -l 10 --abstol 1e-10  --reltol 1e-09  --obiwan ${spec_out}/sphere_td.nft ${benchmark_output}/sphere_td.nft"  | tee -a $specdiff_log
	#specdiff -m -l 10 --abstol 1e-10  --reltol 1e-09  --obiwan ${spec_out}/sphere_td.nft ${benchmark_output}/sphere_td.nft | tee -a $specdiff_log
	
elif  [ $target = "462.libquantum" ]; then
	echo "#specdiff $target input-$2 " | tee -a $specdiff_log
	echo "specdiff -m -l 10 --obiwan ${spec_out}/$output ${benchmark_output}/$output"  | tee -a $specdiff_log
	#specdiff -m -l 10 --obiwan ${spec_out}/$output ${benchmark_output}/$output | tee -a $specdiff_log
	
elif  [ $target = "464.h264ref" ]; 	then
	echo "shortage some compares" | tee -a $specdiff_log
	echo "#specdiff $target input-$2 " | tee -a $specdiff_log
	echo "specdiff -m -l 10 --cw ${spec_out}/$output ${benchmark_output}/$output" v
	#specdiff -m -l 10 --cw ${spec_out}/$output ${benchmark_output}/$output | tee -a $specdiff_log

elif  [ $target = "465.tonto" ]; 	then
	echo "465.tonto without define!" | tee -a $specdiff_log
	
elif  [ $target = "470.lbm" ]; 		then
	echo "#specdiff $target input-$2 " | tee -a $specdiff_log
	echo "specdiff -m -l 10 --abstol 1e-07 ${spec_out}/$output ${benchmark_output}/$output"  | tee -a $specdiff_log
	#specdiff -m -l 10 --abstol 1e-07 ${spec_out}/$output ${benchmark_output}/$output | tee -a $specdiff_log
	
elif  [ $target = "471.omnetpp" ]; 	then
	echo "#specdiff $target input-$2 " | tee -a $specdiff_log
	echo "specdiff -m -l 10 --abstol 1e-06  --reltol 1e-05 ${spec_out}/omnetpp.log ${benchmark_output}/omnetpp.log"  | tee -a $specdiff_log
	#specdiff -m -l 10 --abstol 1e-06  --reltol 1e-05 ${spec_out}/omnetpp.log ${benchmark_output}/omnetpp.log | tee -a $specdiff_log
	echo "specdiff -m -l 10 --abstol 1e-06  --reltol 1e-05 ${spec_out}/omnetpp.sca ${benchmark_output}/omnetpp.sca"  | tee -a $specdiff_log
	#specdiff -m -l 10 --abstol 1e-06  --reltol 1e-05 ${spec_out}/omnetpp.sca ${benchmark_output}/omnetpp.sca | tee -a $specdiff_log
	
elif  [ $target = "473.astar" ];	then
	echo "#specdiff $target input-$2 " | tee -a $specdiff_log
	echo "specdiff -m -l 10 --reltol 0.001 ${spec_out}/$output ${benchmark_output}/$output"  | tee -a $specdiff_log
	#specdiff -m -l 10 --reltol 0.001 ${spec_out}/$output ${benchmark_output}/$output | tee -a $specdiff_log
	
elif  [ $target = "481.wrf" ]; 		then
	echo "#specdiff $target input-$2 " | tee -a $specdiff_log
	echo "specdiff -m -l 10 --abstol 0.01  --reltol 0.05 ${spec_out}/$output ${benchmark_output}/$output"  | tee -a $specdiff_log
	#specdiff -m -l 10 --abstol 0.01  --reltol 0.05 ${spec_out}/$output ${benchmark_output}/$output | tee -a $specdiff_log
	
elif  [ $target = "482.sphinx3" ]; 	then
	echo "#specdiff $target input-$2 " | tee -a $specdiff_log
	echo "specdiff -m -l 10 --reltol 0.001  --floatcompare ${spec_out}/an4.log ${benchmark_output}/an4.log"  | tee -a $specdiff_log
	#specdiff -m -l 10 --reltol 0.001  --floatcompare ${spec_out}/an4.log ${benchmark_output}/an4.log | tee -a $specdiff_log
	echo "specdiff -m -l 10 --reltol 1e-06  --floatcompare ${spec_out}/total_considered.log ${benchmark_output}/total_considered.log"  | tee -a $specdiff_log
	#specdiff -m -l 10 --reltol 1e-06  --floatcompare ${spec_out}/total_considered.log ${benchmark_output}/total_considered.log | tee -a $specdiff_log
	echo "specdiff -m -l 10 --reltol 0.0004  --floatcompare ${spec_out}/considered.log ${benchmark_output}/considered.log"  | tee -a $specdiff_log
	#specdiff -m -l 10 --reltol 0.0004  --floatcompare ${spec_out}/considered.log ${benchmark_output}/considered.log | tee -a $specdiff_log
	
elif  [ $target = "483.xalancbmk" ]; then
	echo "#specdiff $target input-$2 " | tee -a $specdiff_log
	echo "specdiff -m -l 10 ${spec_out}/$output ${benchmark_output}/$output" | tee -a $specdiff_log
	#specdiff -m -l 10 ${spec_out}/$output ${benchmark_output}/$output | tee -a $specdiff_log

elif  [ $target = "999.specrand" ]; then
	echo "#specdiff $target input-$2 " | tee -a $specdiff_log
	echo "specdiff -m -l 10 --floatcompare ${spec_out}/$output ${benchmark_output}/$output" | tee -a $specdiff_log
	#specdiff -m -l 10 --floatcompare ${spec_out}/$output ${benchmark_output}/$output | tee -a $specdiff_log
	
else
	echo "input wrong!"
	exit
fi

#make it can run 
chmod a+x $specdiff_log
