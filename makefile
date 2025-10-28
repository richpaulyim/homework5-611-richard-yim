# Define files
RMD = homework5_611_clustering_Richard_Yim.Rmd
HTML = homework5_611_clustering_Richard_Yim.html
dir1 = task1
dir2 = task2
FIGURES = $(dir1)/task1_figure.png $(dir2)/task2_figure.png

# Default target
all: $(dir1)/task1_figure.png $(dir2)/task2_figure.png $(HTML) 

# task 1 =======================================================================
# generating the cluster gap data
$(dir1)/task1_data.csv: $(dir1)/task1_simulation.R
	Rscript $(dir1)/task1_simulation.R

# generate cluster gap figure
$(dir1)/task1_figure.png: $(dir1)/task1_data.csv $(dir1)/task1_simulation.R $(dir1)/task1_figure.R
	Rscript $(dir1)/task1_figure.R
# ==============================================================================

# task 2 =======================================================================
# generating the optimal k data
$(dir2)/task2_data.csv: $(dir2)/task2_simulation.R $(dir2)/task2_helpers.R
	Rscript $(dir2)/task2_simulation.R

# generate optimal k figure
$(dir2)/task2_figure.png: $(dir2)/task2_data.csv $(dir2)/task2_simulation.R $(dir2)/task2_helpers.R $(dir2)/task2_figure.R
	Rscript $(dir2)/task2_figure.R
# ==============================================================================

# Knit RMD to HTML
$(HTML): $(RMD) $(FIGURES) $(dir2)/task2_helpers.R
	Rscript -e "rmarkdown::render('$(RMD)')"

# Clean up
clean:
	rm -f $(HTML)
	rm -f *.log *.aux *.tex
# rebuild
rebuild: clean all

.PHONY: all clean rebuild