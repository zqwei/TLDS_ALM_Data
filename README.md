# Introduction

This an ensemble of supporting codes for **An orderly single-trial organization of population dynamics in premotor cortex predicts behavioral variability**, which can be used for a general purpose for neural population analyses on single trials.

**The documentation is still under construction** (This line will be removed as it completed).

# Data
Current data is stored at [figshare](https://figshare.com/articles/Simultaneous_extracellular_electrophysiology_data/7372898/3).
The `setDir` code in folder `Func` will automatically download the code at **every** run. One can remove the download code as the data is already downloaded.

## Code and Figures
### Single neuron selectivity
* Figure 1b (left): `SingleUnitAnalysis/ZscoreTime.m`
* Figure 1b (right): `SingleUnitAnalysis/ZscoreTimeSound.m`
### Coding direction rotations
* Figure S1a-f: `SingleUnitAnalysis/SimilarityLDA_LDA.m`
* Figure S1j-l: `SingleUnitAnalysis/SimilarityLDA_LDA_Sound.m`
### Neural dynamics onto coding directions
* Figure S1g-i: `SingleUnitAnalysis/LDAScoreShuffledTrial.m`
* Figure S1m-o: `SingleUnitAnalysis/LDAScoreShuffledTrialSound.m`

# Analyses Details
## Population dynamical system fits
All population dynamical system fits codes are provided in folder `SimultaneousRecordingsFits` using data pre-downloaded from [figshare](https://figshare.com/articles/Simultaneous_extracellular_electrophysiology_data/7372898/3).
### EDLDS
EDLDS fit is as submodule forked from [Epoch-Dependent-LDS-Fit](https://github.com/zqwei/Epoch-Dependent-LDS-Fit).
### GPFA
The [matlab code](http://users.ece.cmu.edu/~byronyu/software/gpfa0203.tgz) is from Byron Yu's lab. If you are interested to use the code in this repo to perform GPFA fits (aka _our implementations_), please set the directory of code to folder `gpfa_v0203`.
* `fitGPFAoptDim`: fit for correct trial data and obtain optimal latent dimension.
* `fitGPFAoptDimErrData`: apply correct trial fit to error trial data.

### sLDS
sLDS fit is done using code from [pyslds](https://github.com/mattjj/pyslds). The implementation code is sent upon request.
## Populational dynamics analyses
### Clustered single unit selectivity
### Sparse LDA

# License

MIT

# Citation
[Wei et al. (2019)](https://www.nature.com/articles/s41467-018-08141-6): An orderly single-trial organization of population dynamics in premotor cortex predicts behavioral variability. Nature Communications 10, 216 (2019).

[Wei et al. (2018)](https://www.biorxiv.org/content/early/2018/07/25/376830): An orderly single-trial organization of population dynamics in premotor cortex predicts behavioral variability. (*The content is slightly different due to the word limitation in the published version*).

# Contacts
Please be free to contact **Ziqiang Wei** (weiz at janelia dot hhmi dot org) for general questions about codes and **Shaul Druckmann** (shauld at stanford dot edu) for discussion about the paper. We will write you back at the earliest convenience.
