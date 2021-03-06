#!/bin/bash -l

## define variables
CMD_PREFIX="echo"    # Please make "echo" to "" for actual running
CODE="RQ2"

NUM_RUNS=50
NUM_TEST=10
EXP_NAME="2_ratioAperiodic"  # Experiment name
NCPU=1               # We test EXPs on a single processor
SIM_TIME=2000        # Simulation time, it is different depends on a EXP
TIME_QUANTA=0.1      # Unit of time, all EXPs use 0.1ms

# EXP variables
TASKSET_NUM=10      # number of task sets

##################################################################
# conducting experiments
# it is better to run below experiments on multiple nodes
##################################################################
for ((control=5; control<=50; control+=5)); do
    ratioValue=`echo "${control} 0.01"|awk '{printf "%.2f", $1*$2}'` # convert $control into percentage value
    for ((tsIdx=0; tsIdx<${TASKSET_NUM}; tsIdx++)); do
        # Path settings
        WORKPATH=${CODE}/${EXP_NAME}/${ratioValue}/${tsIdx}
        TESTPOOL="TestPool/${WORKPATH}"
        formatIDX=$(printf '%03d' "${tsIdx}")
        RESOURCE="res/synthetics/${EXP_NAME}/${ratioValue}/taskset_${formatIDX}.csv"

        # Generate test arrivals (Adaptive random search)
        ${CMD_PREFIX} java -jar artifacts/OPAM.jar -w ${TESTPOOL} --data ${RESOURCE} --max ${SIM_TIME} --quanta ${TIME_QUANTA} --numTest ${NUM_TEST} --cycle 1 --workType Adaptive

        # Execute OPAM (${NUM_RUNS} runs will be executed)
        ${CMD_PREFIX} java -jar artifacts/OPAM.jar --runCnt ${NUM_RUNS} -w ${WORKPATH} --data ${RESOURCE} --testPath ${TESTPOOL}/test.list --max ${SIM_TIME} --quanta ${TIME_QUANTA} --numTest ${NUM_TEST} --cpus ${NCPU} --maxMissed 1000
    done
done


# Collecting results
${CMD_PREFIX} ~/venv/bin/python3  scripts/Python/ResultCollector.py -f merge_fitness -t results/${CODE}/${EXP_NAME}
${CMD_PREFIX} ~/venv/bin/python3  scripts/Python/ResultCollector.py -f merge_time -t results/${CODE}/${EXP_NAME}



