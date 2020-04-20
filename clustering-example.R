library(tidyverse)
library(historydata)

data <- paulist_missions %>%
  select(duration_days, converts, confessions) %>%
  filter(!is.na(confessions))

clusters <- kmeans(data, centers = 10)

clusters_tidy <- tidy(clusters)
data_clustered <- augment(clusters, data)

ggplot(data_clustered, aes(x = duration_days, y = confessions,
                           color = .cluster)) +
  geom_point()


# Hierarchical clustering

h_clusters <- hclust(dist(data))
plot(h_clusters)
