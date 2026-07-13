# Borcherding et al. 2024 — pan-cancer tumour-infiltrating NK cells (re-analysis)

Re-analysis of the publicly available single-cell dataset from:

> **Borcherding N, Vishwakarma A, Voigt AP, et al. Pan-cancer profiling of tumor-infiltrating natural killer cells through transcriptional reference mapping.**  
> *Nature Immunology* 2024. https://doi.org/10.1038/s41590-024-01884-z  
> Data: See original publication / associated reference-mapping resource

## Dataset at a glance
- **System:** Pan-cancer tumour-infiltrating NK cells (transcriptional reference mapping)
- **Assay:** Integrated scRNA-seq reference
- **Accession / source:** See original publication / associated reference-mapping resource

## What this repository does
Processes the pan-cancer tumour-infiltrating NK-cell reference and examines NKG7 and TLR2 expression (including in renal cell carcinoma), with differential-expression analyses. See the numbered `scripts/01–05_*.Rmd` files.

## Repository structure
- `scripts/` — analysis pipeline (numbered `.Rmd` scripts run in order)
- `Setup.R` / `Load_packages.R` — environment setup and package loading
- Large data objects are **not** tracked in Git — download from the source above.

---
Part of my NK / T-cell single-cell research programme — see my [GitHub profile](https://github.com/Eomesodermin) and [dilloncorvino.com](https://dilloncorvino.com).  
Author: **Dillon Corvino**

## Environment

Built in **R** with a Seurat-based single-cell stack — key packages: `Seurat`, `SeuratDisk`, `scCustomize`, `dplyr`, `ggplot2`, `Scillus`, plus my helper package [`r-utility-functions`](https://github.com/Eomesodermin/r-utility-functions).

A pinned `renv.lock` is **not** committed for this repository. To capture an exact, reproducible
environment, run in the project root:

```r
install.packages("renv")
renv::init()        # discovers dependencies from the scripts
renv::snapshot()    # writes renv.lock pinning every package version
```
