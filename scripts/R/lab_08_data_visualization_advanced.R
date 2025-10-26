# Load libraries
library(ggplot2)
library(patchwork)   # For multi-panel layout
library(RColorBrewer)

# 1. Basic scatterplot with color by species
p1 <- ggplot(iris, aes(x = Sepal.Length, y = Sepal.Width, color = Species)) +
  geom_point(size = 3, alpha = 0.8) +  # alpha handles overplotting
  scale_color_brewer(palette = "Dark2") +  # colorblind-friendly palette
  theme_minimal(base_size = 14) +
  labs(title = "Sepal Dimensions by Species",
       x = "Sepal Length (cm)",
       y = "Sepal Width (cm)")

# 2. Add a smoothed trend line (advanced plot layer)
p2 <- ggplot(iris, aes(x = Sepal.Length, y = Sepal.Width, color = Species)) +
  geom_point(size = 2, alpha = 0.5) +
  geom_smooth(method = "lm", se = FALSE) +  # linear trends
  scale_color_brewer(palette = "Set1") +
  theme_classic(base_size = 14) +
  labs(title = "Sepal Length vs Width with Trend Lines")

# 3. Faceted plot (multi-panel figure)
p3 <- ggplot(iris, aes(x = Petal.Length, y = Petal.Width, color = Species)) +
  geom_point(alpha = 0.7) +
  facet_wrap(~ Species) +
  scale_color_brewer(palette = "Paired") +
  theme_light(base_size = 14) +
  labs(title = "Petal Dimensions by Species (Faceted)")

# 4. Violin + boxplot (advanced plot type)
p4 <- ggplot(iris, aes(x = Species, y = Sepal.Length, fill = Species)) +
  geom_violin(alpha = 0.5) +
  geom_boxplot(width = 0.1, outlier.shape = NA) +  # overlay boxplot
  scale_fill_brewer(palette = "Set2") +
  theme_minimal(base_size = 14) +
  labs(title = "Distribution of Sepal Length by Species")


# 5. Combine multi-panel figure using patchwork
combined <- (p1 | p2) / (p3 | p4) + plot_annotation(title = "Advanced ggplot2 Examples with Iris Dataset")

# Display combined figure
print(combined)

# 6. Export options
# Vector graphic (scales cleanly, best for publication)
ggsave("iris_figure_vector.pdf", plot = combined, width = 12, height = 8, dpi = 72)

# Bitmap graphic (requires resolution specification)
ggsave("iris_figure_bitmap.png", plot = combined, width = 12, height = 8, dpi = 72)
ggsave("iris_figure_bitmap300.png", plot = combined, width = 12, height = 8, dpi = 300)
ggsave("iris_figure_bitmap600.png", plot = combined, width = 12, height = 8, dpi = 600)

# 7. Automation / reproducibility example: loop through Species to create individual plots
species_list <- unique(iris$Species)
for (sp in species_list) {
  p <- ggplot(subset(iris, Species == sp), aes(x = Sepal.Length, y = Sepal.Width)) +
    geom_point(color = "steelblue", size = 3, alpha = 0.7) +
    theme_minimal(base_size = 14) +
    labs(title = paste("Sepal Dimensions for", sp),
         x = "Sepal Length (cm)",
         y = "Sepal Width (cm)")
  ggsave(paste0("iris_sepal_", sp, ".pdf"), plot = p, width = 6, height = 4)
}

