# KatzenAnalyser

This repository contains:
- scripts to run experiments on a docker testbed of the katzenpost mixnet 
- a python script to analyse data produced by such experiments

---
### Disclaimer
This testbed is given as is and won't be updated to work with the most recent version of the katzenpost mixnet.  
If you would like to work with the most recent version of the katzenpost mixnet, checkout their repo -> [katzenpost](https://github.com/katzenpost)

---

Implementation
--------------

The simulation is run inside a docker container. This ensures a clean environment on every run as well as the ports used by the different network nodes not being exposed to the local machine. Thus, several simulations can be run simultaneously without interfering with one another.  
### What's under the hood?
The go code for producing the go-executables (preinstalled in the docker container) used for the experiments can be found in [this](https://github.com/LasseWolter/katzenpost_exp_env) repository.

Installation and Setup
----------------------

The following steps describe how to install, setup and run the simulation.

1.  Make sure you have docker installed - why docker? see [Implementation](#implementation)

    -   If you don’t have docker installed, follow the installation guide here: <https://docs.docker.com/install/>

2.  Pull the mixnet docker image from docker hub using the following command:
    `sudo docker pull crosscoder/mix_net:v2` (if you can run docker without sudo you can just leave out `sudo`)

3.  Clone the KatzenAnalyser repo using:
    ` git clone https://github.com/LasseWolter/KatzenAnalyser.git`

    -   this contains two bash files for running a single/a bunch of experiments and one sample config file (some more comments need to be added)

4.  Go into the KatzenAnalyser repo using: cd KatzenAnalyser

5.  Run `./runAll.sh` without any arguments to see its usage:  
    `Usage ./runAll.sh <expConfig> <queueLogDir> <expName> <expNum> <maxSyncRuns>`

    -   **expConfig:** the config file for the experiments -&gt; e.g. sample.toml

    -   **queueLogDir:** top-level directory in which all the logs/results are supposed to be stored - also see \[dirStruc\]

    -   **expName**: Name of your experiment - will determine the experiment dir inside the &lt;queueLogDir&gt; directory as shown in [Directory Structure](#directory-structure)

    -   **expNum**: number of experiment iterations you want to run

    -   **maxSyncRuns**: MaxNumber of experiments that are run at the same time (not guaranteed because of hacky implementation but functional)

6.  Run the ./runAll.sh with any arguments you would like to use, e.g.  
    ` sudo ./runAll.sh sample.toml queue_outputs test_exp 10 5` (again, you can possibly leave out sudo if you can run docker without it)

    -   this e.g. will run 10 experiments where 5 experiments are run at a time (thus, you’ll have 2 rounds) using the sample.toml as config and creating your outputs in the folder `queue_outputs/test_exp`

        -   namely in 10 output folders called exp01, exp02 ... exp10

7.  You’ll find your outputs in the &lt;queueLogDir&gt; directory as described above

### Directory structure

Each runAll.sh creates a directory within &lt;queueLogDir&gt; named &lt;expName&gt;

-   in this &lt;expName&gt; directory N directories named expN (according to the experiment number) will be created

-   Thus running ./runAll.sh will give you the following directory structure

    -   &lt;queueLogDir&gt;/

        -   &lt;expName&gt;/

            -   exp01/

            -   exp02/

            -   ...

            -   expN/

-   For each experiment expN you’ll have the following files

    -   `ql_serviceprovider:` contains the msg queue length logs from the serviceprovider

    -   `ql_provider:` contains the msg queue length logs from the provider

    -   `ql_mix1:` contains the msg queue length log from mix one

    -   **log/**: directory containing logs about the different nodes as well as the authority and services
