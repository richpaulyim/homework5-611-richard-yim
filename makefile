# Define files
RMD = homework5_611_clustering_Richard_Yim.Rmd
PDF = homework5_611_clustering_Richard_Yim.pdf
FIGURES = task1_figure.pdf

# Default target
all: task1_figure.pdf $(PDF) 

# task 1 =======================================================================
# generating the cluster gap data
task1_data.csv: task1_simulation.R
	Rscript task1_simulation.R

# generate cluster gap figure
task1_figure.pdf: task1_data.csv task1_simulation.R
	Rscript task1_figure.R
# ==============================================================================

# task 2 =======================================================================
# generating the cluster gap data
#task1_data.csv: cluster_gap_statistic.R
#	Rscript cluster_gap_statistic.R
## generate cluster gap figure
#cluster_gap_analysis.png: task1_data.csv cluster_gap_statistic.R
#	Rscript task1_figure.R
# ==============================================================================

# Knit RMD to PDF
$(PDF): $(RMD) $(DATA) $(SCRIPTS)
	Rscript -e "rmarkdown::render('$(RMD)')"

# Clean up
clean:
	rm -f $(PDF)
	rm -f *.log *.aux *.tex
# rebuild
rebuild: clean all

.PHONY: all clean rebuild