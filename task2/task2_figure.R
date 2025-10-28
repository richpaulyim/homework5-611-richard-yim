library(tidyverse)
library(ggplot2)
# non interactive run
pdf(NULL)

results_long <- read_csv("task2_data.csv")

# Add max_radius column (decreasing from 10 to 0 by 1)
results_long <- results_long %>%
  mutate(max_radius = seq(10, 0, by = -1))

# Create the plot
plot <- ggplot(results_long, aes(x = max_radius, y = optimal_k)) +
  geom_line(linewidth = 1, color = "steelblue") +
  geom_point(size = 2, color = "steelblue") +
  geom_hline(yintercept = 4, linetype = "dashed", color = "red", linewidth = 0.8) +
  labs(
    x = "Maximum Radius",
    y = "Number of Clusters",
    title = "Number of Clusters vs Maximum Radius"
  ) +
  theme_minimal() +
  theme(
    plot.title = element_text(hjust = 0.5, size = 14, face = "bold"),
    axis.title = element_text(size = 12),
    axis.text = element_text(size = 10)
  )

# Save the plot
ggsave("task2_figure.png", plot = plot, width = 10, height = 5)