# Introduction

This an ensemble of supporting codes for **An orderly single-trial organization of population dynamics in premotor cortex predicts behavioral variability**, which can be used for a general purpose for neural population analyses on single trials.

**The documentation is still under construction** (This line will be removed as it completed).

# Data
Current data is stored at [figshare](https://figshare.com/articles/Simultaneous_extracellular_electrophysiology_data/7372898/3).
The `setDir` code in folder `Func` will automatically download the code at **every** run. One can remove the download code as the data is already downloaded.

# Analyses
## Population analyses
### Single neuron selectivity
* Figure 1b (left): `SingleUnitAnalysis/ZscoreTime.m`
* Figure 1b (right): `SingleUnitAnalysis/ZscoreTimeSound.m`
### Coding direction rotations (based on Sparse LDA)
* Figure S1a-f: `SingleUnitAnalysis/SimilarityLDA_LDA.m`
* Figure S1j-l: `SingleUnitAnalysis/SimilarityLDA_LDA_Sound.m`
### Neural dynamics onto coding directions
* Figure S1g-i: `SingleUnitAnalysis/LDAScoreShuffledTrial.m`
* Figure S1m-o: `SingleUnitAnalysis/LDAScoreShuffledTrialSound.m`
### Rank dynamics
* Figure 4c-f, Figure S5: `SimultaneousRecordingsAnalysis/timeLDA.m`
* Figure 4g-h, Figure S6: `SimultaneousRecordingsAnalysis/rankSimilarityComparisonPlots.m`
* Figure 5a-b: `SimultaneousRecordingsAnalysis/rankDynamics.m`
### Trial type decodability
### Reaction time
### Error trial decodability
### Explained variance
* Figure 2d: `SimultaneousRecordingsAnalysis/EV_correct_refline.m`
* Figure 6b: `SimultaneousRecordingsAnalysis/EV_correct_error.m`


## Population dynamical system fits
All population dynamical system fits codes are provided in folder `SimultaneousRecordingsFits` using data pre-downloaded from [figshare](https://figshare.com/articles/Simultaneous_extracellular_electrophysiology_data/7372898/3).
### EDLDS
EDLDS fit is as submodule forked from [Epoch-Dependent-LDS-Fit](https://github.com/zqwei/Epoch-Dependent-LDS-Fit).
* `fitEDLDSModel`: fit for 4 types of EDLDS models
    * model 1 -- constant W(mode) and W(projection)
    * model 2 -- constant W(mode)
    * model 3 -- constant W(projection)
    * model 4 -- variable W(mode) and W(projection)
* `fitEDLDSoptDim` : refit EDLDS models at optimal dimensions (the optimal dimensions are estimated from `fitEDLDSModel`).
* `fitEDLDSoptDimTrace` : fit EDLDS dynamics at optimal dimensions in correct trials
* `fitEDLDSoptDimErrorTrace` : fit EDLDS dynamics at optimal dimensions in error trials
* These codes can generate **Figures 2b, 2c, 6a, S2a, S2b**

### GPFA
The [matlab code](http://users.ece.cmu.edu/~byronyu/software/gpfa0203.tgz) is from Byron Yu's lab. If you are interested to use the code in this repo to perform GPFA fits (aka _our implementations_), please set the directory of code to folder `gpfa_v0203`.
* `fitGPFAoptDim`: fit for correct trial data and obtain optimal latent dimension.
* `fitGPFAoptDimErrData`: apply correct trial fit to error trial data.
* These codes can generate **Figures 2b, 2c, S2a**

### sLDS
sLDS fit is done using code from [pyslds](https://github.com/mattjj/pyslds). The implementation code is sent upon request.
* These codes can generate **Figures 2c, S2a, S2c**

## Figure not included
* Figure 1a, 4a-b, 7: schematics
* Figure 2d, 5c-g, : can be recreated using other codes (code can be shared upon requests)

# License
MIT

# Citation
[Wei et al. (2019)](https://www.nature.com/articles/s41467-018-08141-6): An orderly single-trial organization of population dynamics in premotor cortex predicts behavioral variability. Nature Communications 10, 216 (2019).

[Wei et al. (2018)](https://www.biorxiv.org/content/early/2018/07/25/376830): An orderly single-trial organization of population dynamics in premotor cortex predicts behavioral variability. (*The content is slightly different due to the word limitation in the published version*).

# Contacts
Please be free to contact **Ziqiang Wei** (weiz at janelia dot hhmi dot org) for general questions about codes and **Shaul Druckmann** (shauld at stanford dot edu) for discussion about the paper. We will write you back at the earliest convenience.
