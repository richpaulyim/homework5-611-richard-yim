# BIOS 611 - Homework 5: Clustering Analysis

This repository contains the implementation and analysis for BIOS 611 Homework 5. The project explores two key clustering analysis tasks: evaluating gap statistics for determining optimal cluster counts in high-dimensional data, and implementing spectral clustering on non-convex shell-shaped clusters.

The response to homework questions can be found in `homework5_611_clustering_Richard_Yim.html`. Pleaes download the html file and open in a web browser to render the responses and results.

## Project Structure

```
/home/rstudio/work/
├── README.md                                    # Project documentation
├── makefile                                     # Build automation file
├── homework5_611_clustering_Richard_Yim.Rmd   # RMarkdown analysis document
├── homework5_611_clustering_Richard_Yim.html  # Generated HTML report
├── task1/                                       # Task 1: Gap Statistics Analysis
│   ├── task1_simulation.R                       # Simulation code
│   ├── task1_figure.R                           # Figure generation
│   ├── task1_data.csv                           # Generated data
│   └── task1_figure.png                         # Generated visualization
├── task2/                                       # Task 2: Spectral Clustering Analysis
│   ├── task2_simulation.R                       # Simulation code
│   ├── task2_helpers.R                          # Helper functions
│   ├── task2_data.csv                           # Generated data
│   └── task2_figure.png                         # Generated visualization
└── .claude/                                      # Claude configuration
    └── settings.local.json                      # Local settings
```

## File Descriptions

### Root Level Files

#### makefile
Build automation tool that orchestrates the entire analysis pipeline. Key targets include:
- `all`: Builds both task figures and the HTML report
- Task 1 pipeline: Runs simulation, generates data, and creates figures
- Task 2 pipeline: Runs simulation with helper functions, generates data and figures
- `html`: Knits RMarkdown document into HTML using `rmarkdown::render()`
- `clean`: Removes generated HTML and LaTeX artifacts
- `rebuild`: Performs a clean rebuild of all targets

#### homework5_611_clustering_Richard_Yim.Rmd
RMarkdown document serving as the main analysis report. Contains:
- Task 1 analysis: Discussion of gap statistics performance across dimensions
- Task 2 analysis: Interactive 3D visualization of concentric shell clusters
- Detailed discussion of spectral clustering sensitivity to threshold parameters
- Embedded figures from both tasks for visual analysis

### Task 1: Gap Statistics Analysis for Hypercube Clusters

**Purpose**: Evaluate the performance of the gap statistics method for determining the optimal number of clusters in hypercube-shaped data across varying dimensions and cluster separations.

#### task1/task1_simulation.R
Generates hypercube cluster data and computes gap statistics across multiple conditions.

**Main Function**: `generate_hypercube_clusters(n, k, side_length, noise_sd)`
- `n`: Number of dimensions
- `k`: Number of clusters
- `side_length`: Controls cluster separation (larger values = better separated clusters)
- `noise_sd`: Gaussian noise standard deviation

**Simulation Parameters**:
- Tests dimensions: 2, 3, 4, 5, 6
- Tests side lengths: 1-10 (10 levels)
- Total: 50 simulation runs with 100 clusters each
- Uses `clusGap()` from cluster package with K.max = 10
- Employs `maxSE()` with "firstSEmax" method to determine optimal K

**Output**: CSV with columns (dimensions, side_length, optimal_k)

#### task1/task1_figure.R
Creates a faceted line plot visualizing gap statistic results.

**Features**:
- 5 facets (one per dimension)
- X-axis: side_length (1-10)
- Y-axis: optimal_k (estimated number of clusters)
- Red dashed reference line showing true number of clusters
- Shows how gap statistics performance degrades with overlapping clusters

#### task1/task1_data.csv
Contains 50 rows of simulation results showing optimal cluster counts for each combination of dimensions and side_length.

#### task1/task1_figure.png
Five-panel faceted plot demonstrating dimension-dependent sensitivity of gap statistics.

### Task 2: Spectral Clustering with Shell Topology

**Purpose**: Analyze how spectral clustering performs on concentric shell (sphere surface) clusters and determine optimal cluster count as a function of shell separation.

#### task2/task2_helpers.R
Contains two critical functions for shell generation and spectral clustering:

**1. `generate_shell_clusters(n_shells, k_per_shell, max_radius, noise_sd)`**
Generates n_shells concentric spherical shells in 3D space.
- Radii evenly spaced from minimum to maximum radius
- Uses radius-scaled sampling: Each shell gets `radius^2 * k_per_shell` points
- Employs spherical coordinates for uniform surface distribution
- Converts to Cartesian coordinates (x,y,z)
- Adds Gaussian noise to radius values

**2. `spectral_clustering(x, k, d_threshold)`**
Implements normalized spectral clustering algorithm:
1. Computes pairwise Euclidean distances
2. Builds adjacency matrix based on distance threshold
3. Calculates degree matrix and symmetric normalized Laplacian
4. Performs eigen-decomposition
5. Extracts first k eigenvectors (smallest eigenvalues)
6. Normalizes eigenvector rows
7. Applies kmeans on normalized eigenvectors

#### task2/task2_simulation.R
Tests spectral clustering performance across varying shell separations.

**Simulation Parameters**:
- Tests max_radius: 0-10 (11 levels)
- Fixed: n_shells=4, k_per_shell=10
- Uses `clusGap()` with spectral_clustering function
- K.max = 5, B = 10 bootstrap samples

**Output**: CSV with single column (optimal_k)

#### task2/task2_figure.R
Creates a line plot showing relationship between shell radius and detected cluster count.

**Features**:
- X-axis: max_radius (0-10)
- Y-axis: optimal_k
- Steel blue line and points
- Red dashed reference line at y=4 (true number of shells)
- Illustrates threshold sensitivity in spectral clustering

#### task2/task2_data.csv
Contains 11 rows showing optimal cluster counts for each max_radius value.

#### task2/task2_figure.png
Single plot demonstrating how cluster detection varies with shell separation.

## Building the Project

### Prerequisites
- R 3.x or higher
- Required R packages: `cluster`, `tidyverse`, `ggplot2`, `plotly`, `rmarkdown`

### Build Commands

```bash
# Build everything (data, figures, and HTML report)
make all

# Build individual components
make task1/task1_data.csv      # Run Task 1 simulation
make task1/task1_figure.png    # Generate Task 1 figure
make task2/task2_data.csv      # Run Task 2 simulation
make task2/task2_figure.png    # Generate Task 2 figure
make html                       # Generate HTML report

# Clean generated files
make clean

# Clean and rebuild everything
make rebuild
```

## Data Flow Pipeline

### Task 1 Pipeline
```
task1_simulation.R → task1_data.csv → task1_figure.R → task1_figure.png
                                                              ↓
                                            homework5_611_clustering_Richard_Yim.Rmd
                                                              ↓
                                            homework5_611_clustering_Richard_Yim.html
```

### Task 2 Pipeline
```
task2_helpers.R (sourced by) task2_simulation.R → task2_data.csv → task2_figure.R → task2_figure.png
                                                                                            ↓
                                                                      homework5_611_clustering_Richard_Yim.Rmd
                                                                                            ↓
                                                                      homework5_611_clustering_Richard_Yim.html
```

## Key Findings

### Task 1: Gap Statistics Performance
- Gap statistics successfully identifies correct cluster counts when clusters are well-separated
- Performance degrades as cluster separation decreases (smaller side lengths)
- Higher dimensions show earlier degradation, indicating difficulty with overlapping clusters in high-dimensional spaces

### Task 2: Spectral Clustering Sensitivity
- Spectral clustering effectively handles non-convex shell-shaped clusters
- Performance is sensitive to the distance threshold parameter (τ_d=1 used in this analysis)
- Cluster detection degrades at extreme radius values (very small or very large separations)
- Successfully identifies the true number of shells (4) for moderate separation values

## Technologies Used

- **R**: Statistical computing and analysis
- **cluster**: Gap statistics implementation
- **tidyverse**: Data manipulation
- **ggplot2**: Static data visualization
- **plotly**: Interactive 3D visualization
- **rmarkdown**: Report generation
- **GNU Make**: Build automation

## Author

Richard Paul Yim

Date: October 26, 2025
