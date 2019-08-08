#!/bin/bash

if [ -z "$1" ] || [ -z "$2" ] || [ -z "$3" ] || [ -z "$4" ];
then
    echo "Usage $0 <expConfig> <queueLogDir> <expName> <expNum> <maxSyncRuns>"
    exit 
fi
expConf=$1
queueLogDir=$2
expName=$3
expNum=$4 
maxSyncRuns=$5

printf "\n >>>You are running an experiment with the config: $expConf<<<\n\n"

echo "Spin up $expNum docker containers"
for i in `seq $expNum`
do
    padded_i=$(printf '%02d' $i) # pad single digits with a zero for ordering purposes 
    if (($i %$maxSyncRuns==0 || $i == $expNum)); # Every 10th experiment is run in the forground such that nomore then 10 exp run at the same time
    then 
        ./runExperiment.sh $1 $2 $padded_i 
    else
        ./runExperiment.sh $1 $2 $padded_i &
    fi
done

# On last iteration change permissions for queueLogFolder since it's created with root priveleges 
sudo chown -R $USER:$USER ${queueLogDir}${expName} 
sudo chmod -R 755 ${queueLogDir}${expName} 
