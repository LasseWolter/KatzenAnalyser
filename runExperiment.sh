#!/bin/bash
if [ -z "$1" ] || [ -z "$2" ] || [ -z "$3" ] || [ -z "$4" ];
then
    echo "Usage $0 <expConfig> <queueLogDir> <expName> <expId> <dockerImage>"
    exit 
fi

expConf=$1
queueLogDir=$2
expName=$3
expId=$4
curExpDir="./curExps/"

# Possibility of using a costum docker image
dockerImage=${5:-"crosscoder/mix_net:v2"}

echo "---------------------------------------"
printf "%s\n" "----------Experiment: $expName"
printf "%s\n" "----------Iteration: $expId"
printf "%s\n\n" "---------------------------------------"

# Copy exp config into curExp dir
mkdir -p ${curExpDir}/exp${expId} 
\rm -rf ${curExpDir}/exp${expId}/*
# Replace the QueueLogDir in alice.toml with the expName + expId to have separate folders for each iteration
cp $expConf ${curExpDir}exp${expId}/alice.toml
sed -i "s:QueueLogDir[ =\"0-9A-Za-z_]*:QueueLogDir=\"$expName/exp$expId\":g" ${curExpDir}/exp${expId}/alice.toml 

# Create expName file which only contains the expName+'exp'+iteration such that the container can access it to store logs
echo "$expName/exp$expId" >  ${curExpDir}/exp${expId}/expName

# Make sure the queue_outputs/$expName directory exists
mkdir -p $queueLogDir/$expName

printf "Starting docker container...\n"

# The directory /cliConf is chosen such that effects are not reflected in the mix_net dir on the local machine
# The queue_outputs are mounted such that the results are accessible from the local machine
# The --rm flag causes the docker container to be removed after it's finished running and thus, not waste space on the local machine
docker run --rm -v $PWD/$queueLogDir/$expName:/mix_net/queue_outputs/$expName \
           -v $PWD/$curExpDir/exp${expId}:/cliConf \
           $dockerImage
# If no log directory was created this means that this iteration exited early - thus, rerun this iteration
if [ ! -d "$queueLogDir/$expName/exp$expId/log" ]; then
    echo "Something went wrong, rerunning this experiment iteration..."
    ./runExperiment.sh $1 $2 $3 $4 $5
fi
#printf "Experiment done, creating plots..."
#./queue_outputs/makePlot.sh ./queue_outputs/$expName 
#
#echo "Copying files to googleDrive..."
#cp -rv ./queue_outputs/$expName /home/lasse/g_drive/Work/Research_Internship/Experiments/
