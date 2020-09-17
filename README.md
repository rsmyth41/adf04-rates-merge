# adf04-rates-merge

Code for merging radiative transition rates and rates from shifted energy atomic/ionic collision calculations into a standard ADAS adf04 file. A sample adf04 file, atomic stucture radiative rates and radiative rates due to shifted atomic energy levels are provided as example files. Other input files can be obtained from standard atomic structure and atomic/ionic collision calculations.

Initially created for collisional-radiative calculations with the ColRadPy python package of Johnson et al (https://doi.org/10.1016/j.nme.2019.01.013) implemented for electron-impact calculations involving Fe II(Smyth et al: https://doi.org/10.3390/galaxies6030087, Smyth et al: https://doi.org/10.1093/mnras/sty3198), Mo I (Smyth et al: https://doi.org/10.1103/PhysRevA.96.042713), W I (Smyth et al: https://doi.org/10.1103/PhysRevA.97.052705)

Some internal parameters which must be set prior to compilation:

    nlev        = number of levels in R-matrix calculation
    shiftmax    = number of transitions in shiftedavalue file
    tmax        = maximum avalue index. Set tmax=nlev if we want all avalues
    nline       = Number of lines in adf04 per transition

To compile:

    gfortran adf04RatesMerge.f95 -mcmodel=medium -O3 -o adf04RatesMerge.x

To run

    ./arraySplitter.x