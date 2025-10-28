library(tidyverse)
library(ggplot2)
# non interactive run
pdf(NULL)

results_long <- read_csv("task1/task1_data.csv")
# Create the plot
ggplot(results_long, aes(x = side_length, y = optimal_k)) +
  geom_line(linewidth = 1) +
  geom_point(size = 2) +
  geom_hline(aes(yintercept = dimensions), 
             linetype = "dashed", 
             color = "red", 
             linewidth = 0.8) +
  facet_wrap(~ dimensions, nrow = 1, ncol = 5,
             labeller = labeller(dimensions = function(x) paste("n =", x))) +
  scale_x_continuous(breaks = 1:10) +
  labs(
    x = "Side Length",
    y = "Estimated Number of Clusters",
    title = "Gap Statistic Performance Across Dimensions",
    subtitle = "Red dashed line shows true number of clusters"
  ) +
  theme_bw() +
  theme(
    strip.background = element_rect(fill = "lightgray"),
    strip.text = element_text(size = 11, face = "bold"),
    panel.grid.minor = element_blank()
  )

# Save the plot
ggsave("task1/task1_figure.png", width = 10, height = 5)