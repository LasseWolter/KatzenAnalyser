
# KatzenAnalyser

This repository contains:
- scripts to run experiments on a docker testbed of the [katzenpost mixnet](https://github.com/katzenpost/)
- a python script to analyse data produced by such experiments

---
### Disclaimer
This testbed is given as is and won't be updated to work with the most recent version of the katzenpost mixnet.  
If you would like to work with the most recent version of the katzenpost mixnet, checkout their repo -> [katzenpost](https://github.com/katzenpost)

---

Introduction
------------

The testbed used for the experiments was build on top of the Katzenpost messaging client [catshadow](https://github.com/katzenpost/catshadow). For the purpose of the simulation certain features catshadow provides, like an implementation of rendezvous point, weren’t relevant. Catshadow was merely used as it provided a relatively simple way to establish a message exchange over the katzenpost mixnet, which was essential for the investigations carried out by this research project.

Features
--------

The simulation in its current state has a **fixed** network topology consisting of:

-   *1 Authority*: Acting as PKI system

-   *1 Provider*: Acting as interface to the mixnet for clients

-   *1 Service Provider*: Providing different services, like a remote spool to implement the rendezvous points

-   *1 Mix*: Acting as only mix on the only mix-layer of the network

The User can pass a .toml-config file to the simulation as described in [Installation and Setup](#installation-and-setup). Within this config the user can change the following parameters:

<table>
<thead>
<tr class="header">
<th align="center"></th>
<th align="center"><strong>Parameter</strong></th>
<th align="left"><strong>Unit</strong></th>
<th align="left"><strong>Function</strong></th>
</tr>
</thead>
<tbody>
<tr>
<th colspan=3>
[Experiment]-Section
</th>
</tr>
<tr class="odd">
<td align="center"></td>
<td align="center">Duration</td>
<td align="left">min</td>
<td align="left">Experiment Duration</td>
</tr>
<tr class="even">
<td align="center"></td>
<td align="center">LambdaP</td>
<td align="left"><span class="math inline">1/ms</span></td>
<td align="left">Inverse of the mean delay between two messages sent from client 1/ms</td>
</tr>
<tr class="odd">
<td align="center"></td>
<td align="center">LambdaPMaxDelay</td>
<td align="left">ms</td>
<td align="left">Maximal delay corresponding to LambdaP ms</td>
</tr>
<tr class="even">
<td align="center"></td>
<td align="center">Mu</td>
<td align="left"><span class="math inline">1/ms</span></td>
<td align="left">Inverse of the mean delay at each hop 1/ms</td>
</tr>
<tr class="odd">
<td align="center"></td>
<td align="center">MuMaxDelay</td>
<td align="left">ms</td>
<td align="left">Maximal delay corresponding to Mu</td>
</tr>
<tr class="even">
<td align="center"></td>
<td align="center">QueuePollInterval</td>
<td align="left">ms</td>
<td align="left">Interval at which the server is polled for its message queue length</td>
</tr>
<tr class="odd">
<td align="center"></td>
<td align="center">QueueLogDir</td>
<td align="left">N/A</td>
<td align="left">String defining the directory to which the queue lengths are written</td>
</tr>
<tr>
<th colspan=3>
[[Client]]-Section
</th>
</tr>
<tr class="even">
<td align="center"></td>
<td align="center">Name</td>
<td align="left">N/A</td>
<td align="left">Name of the client</td>
</tr>
<tr>
<th colspan=3>
[[Client.Update]]-Section
</th>
</tr>
<tr>
<tr class="odd">
<td align="center"></td>
<td align="center">Time</td>
<td align="left">min</td>
<td align="left">Time of the update after the experiment has started</td>
</tr>
<tr class="even">
<td align="center"></td>
<td align="center">LambdaP</td>
<td align="left"><span class="math inline">1/ms</span></td>
<td align="left">New value for LambdaP - see above</td>
</tr>
<tr class="odd">
<td align="center"></td>
<td align="center">LambdaPMaxDelay</td>
<td align="left">ms</td>
<td align="left">New value for LamdbdaPMaxDelay - see above</td>
</tr>
</tbody>
</table>


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


Analysing the results
=====================

The repository contains a python script called `analyse.py` which helps analysing the results produced by the experiments. The script produces two types of plots

1.  two plots in each `expN` directory

    -   `whole_duration.png`: consists of two plots - [example fig](#whole-period)

        -   **top**: showing the message queue length of the different nodes over the whole period of the experiment

        -   **bottom**: top plot with convolution applied to it

    -   `only_steady.png`: consists of two plots - [example fig](#only-steady-period)

        -   **top**: showing the message queue length of the different nodes during the steady period of the experiment only - meaning the period during which the message queue lengths are at a steady state

        -   **bottom**: top plot with convolution applied to it - the edges only appear because of the convolution (Applying convolution at the edges causes parts of the window to be multiplied with 0 which causes these rising and falling edges)

2.  a concluding plot in the top-level experiment directory

    -   Showing the mean of means of the queue lengths of the different nodes over all experiment, also displaying error bars

Further all of these plots contain some statistics, namely:

-   **mean**: the mean queue length over the course of the experiment

-   **std**: the standard deviation from this mean

-   **zeroFreq**: the ratio of times which queue length 0 appears to the total number of queue lengths

<a name="example_figs"></a>
### Example figures
#### Whole period
![whole_period](https://user-images.githubusercontent.com/29123172/65533496-a3ebbc80-def5-11e9-83e9-614ef0688811.png)  
#### Only Steady period
![only_steady](https://user-images.githubusercontent.com/29123172/65533504-a64e1680-def5-11e9-9666-82282bbe39d0.png)


Setup and Usage
---------------

The script was developed with python 3.5 and any version above should work as well - backwards compatibility is not guaranteed though.
I recommend creating a new python virtual environment and installing the required dependencies from the `requirements.txt` file by running the following command from within the `KatzenAnalyser\` directory:
`pip install -r requirements.txt`
Now running the script without any arguments will show the usage:
` Usage: analyse.py <exp_dir> <config> (<from_disc>) (<show>)`
**Required arguments**

-   `exp_dir:` The top level directory of the experiment. This directory should contain several directories named `exp01/`, `exp02/`, etc. as described in section \[dirStruc\]

-   `config:` The toml-config file used for the experiment, e.g. sample.toml

**Optional arguments**

-   `(from_disc)`: passing the string `"from_disc"` (without quotation marks) as third argument will read .csv files from disc instead of analysing the raw data from all the `expN/` folders.
    This won’t work the first time you run the script for new results since the .csv files of the statistics are created during the first analysis.
    Once the data has been analysed once, these .csv files can come in handy if the user wants to create/adjust a plot using the same statistics (mean, std, zeroFreq).

-   `(show):` passing the string `"show"` (without quotation marks) as fourth argument will display each plot as it is created.
    Running the script without `"from_disc"` will thus display the plots for each subfolder `expN` - probably this is only useful for debugging purposes.
    Running the script with both `"from_disc"` and `"show"` means that the concluding mean-of-means plot will be displayed which might be useful for debugging and normal usage.
