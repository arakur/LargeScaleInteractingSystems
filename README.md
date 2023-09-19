# Some Implementations for the Large Scale Interacting Systems (for research)

Scripts and modules for the research of the large scale interacting systems with Julia[Julia].
This totally refers to [BKS].

This project is quite under construction and mainly for our own research.
Current status:

- [x] Calculation of the space $\mathrm{Consv}^\phi(S)$ of the conserved quantities
- [x] Combinatorics of interactions and quantities;
  - [x] enumerating and
  - [x] counting
- [ ] Checking if an interaction is exchangeable
- [ ] Computing period matrices
- [ ] Other stuffs

## Setting

1. Install [Julia](https://julialang.org/downloads/) (≥ v1.7.2).
2. Install [Jupyter Notebook](https://jupyter.org/install).
3. Set up Julia kernel for Jupyter Notebook.
4. `git clone "https://github.com/arakur/LargeScaleInteractingSystems"`.
5. Open Jupyter Notebook files `ConservedQuantities.ipynb` and `InteractionsEnumeration.ipynb`.

## Contents

### 1. ConservedQuantities: Calculation a basis of the space $\mathrm{Consv}^\phi(S)$ of the conserved quantities

See the Julia notebook `src/ConservedQuantities.ipynb`.

### 2. InteractionsEnumeration: Enumeration and counting all interactions

See the Julia notebook `src/InteractionsEnumeration.ipynb`.

## References

[BKS]: [Bannai, Kenichi and Kametani, Yukio and Sasada, Makiko. Topological Structures of Large Scale Interacting Systems via Uniform Functions and Forms. 2020.](https://arxiv.org/abs/2009.04699v4)

[Julia]: [Jeff Bezanson, Alan Edelman, Stefan Karpinski, and Viral B. Shah. Julia: A Fresh Approach to Numerical Computing](https://epubs.siam.org/doi/10.1137/141000671)
