#!/bin/bash -l

## define variables
CMD_PREFIX="echo"    # Please make "echo" to "" for actual running
CODE="RQ1"

NUM_RUNS=50
NUM_TEST=10
SUBJECT_NAME="ESAIL"  # Subject name
NCPU=1                # Number of CPUs, Use a different number depends on the subject
SIM_TIME=6000         # Simulation time, only ESAIL has specified simulation time as 60000
TIME_QUANTA=0.1       # Unit of time, only ESAIL uses 0.1ms otherwise, 1
OPTION=''             # This variable is used for RQ3

# Path settings
TESTPOOL="TestPool/${CODE}/${SUBJECT_NAME}"
RESOURCE="res/industrial/${SUBJECT_NAME}.csv"

# Generate test arrivals (Adaptive random search)
${CMD_PREFIX} java -jar artifacts/OPAM.jar -w ${TESTPOOL} --data ${RESOURCE} --max ${SIM_TIME} --quanta ${TIME_QUANTA} --numTest ${NUM_TEST} --cycle 1 --workType Adaptive ${OPTION}


# Execute OPAM (${NUM_RUNS} runs will be executed)
${CMD_PREFIX} java -jar artifacts/OPAM.jar --runCnt ${NUM_RUNS} -w ${CODE}/OPAM/${SUBJECT_NAME} --data ${RESOURCE} --testPath ${TESTPOOL}/test.list --max ${SIM_TIME} --quanta ${TIME_QUANTA} --numTest ${NUM_TEST} --cpus ${NCPU} --maxMissed 1000 ${OPTION}

# Execute RandomSearch (${NUM_RUNS} runs will be executed)
${CMD_PREFIX} java -jar artifacts/OPAM.jar --runCnt ${NUM_RUNS} -w ${CODE}/RS/${SUBJECT_NAME} --data ${RESOURCE} --testPath ${TESTPOOL}/test.list --max ${SIM_TIME} --quanta ${TIME_QUANTA} --numTest ${NUM_TEST} --cpus ${NCPU} --maxMissed 1000 --algo1 RandomSearch --simpleP2 ${OPTION}


# Collecting results
#${CMD_PREFIX} python3  scripts/Python/ResultCollector.py -f merge_fitness_industrial -t results/${CODE}/OPAM -o results/${CODE}/fitness_OPAM.csv
#${CMD_PREFIX} python3  scripts/Python/ResultCollector.py -f merge_fitness_industrial -t results/${CODE}/RS -o results/${CODE}/fitness_RS.csv
#${CMD_PREFIX} python3  scripts/Python/ResultCollector.py -f merge_time_industrial -t results/${CODE}/OPAM -o results/${CODE}/timeinfo_OPAM.csv
#${CMD_PREFIX} python3  scripts/Python/ResultCollector.py -f merge_time_industrial -t results/${CODE}/RS -o results/${CODE}/timeinfo_RS.csv

# Evaluate the values
#${CMD_PREFIX} java -jar artifacts/QI.jar -w OPAM,RS --compare1 ${CODE}/fitness_OPAM.csv --compare2 ${CODE}/fitness_RS.csv --output ${CODE}/fitness_QI.csv --runCnt ${NUM_RUNS} --cycle 1000



