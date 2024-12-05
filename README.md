# HigherOrderPLSPM_Prime

### Author:
Gyeongcheol Cho and Heungsun Hwang

## Description:
- The **HigherOrderPLSPM_Prime** package enables users to estimate and evaluate PLSPM models with higher-order constructs.

## Features:
- Estimate model parameters and calculate their standard errors (SE) along with 95% confidence intervals (CI).
- Enable parallel computing for bootstrap sampling.
- Allow users to specify a sign-fixing indicator for each component.

## Installation:
To use this package in MATLAB:
1. Clone or download the repository:
   ```bash
   git clone https://github.com/GyeongcheolCho/HigherOrderPLSPM_Prime.git
   ```
2. Add the package to your MATLAB path:
   ```matlab
    addpath(genpath('HigherOrderPLSPM_Prime'))
   ```
## Dependencies:
- This package is dependent on BasicPLSPM_Package (Hwang & Cho, 2024) If you haven't installed this package, run the following command: `Check_Dependencies`                                          %

## Usage:
- For examples on how to use the package, refer to the `Run_Example_HigherOrderPLSPM_Prime.m` file. This file demonstrates the implementation of `HigherOrderPLSPM_Prime()` using the `rick2.csv` dataset.

## Compatibility:
- Tested on MATLAB R2023b.
- Likely compatible with earlier MATLAB versions.

### Citation (APA):
- If you use **HigherOrderPLSPM_Prime** in your research or publications, please cite it in APA format as follows:

```plaintext
Cho, G. & Hwang, H. (2024). HigherOrderPLSPM_Prime: A package for partial least squares path modeling with higher-order constructs [Computer software]. GitHub. https://github.com/GyeongcheolCho/HigherOrderPLSPM_Prime
```
