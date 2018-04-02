# Train a word2vec model

# Make sure you have the wordVectors package. You only need to run this line once.
# devtools::install_github("bmschmidt/wordVectors")

library(wordVectors)
library(tidyverse)
library(ggrepel)

# Turn the directory of texts into a format that wordVectors expects
prep_word2vec(origin = "ats", destination = "ats.corpus", lowercase = TRUE)

# Train the model
ats_model <- train_word2vec(train_file = "ats.corpus", output_file = "ats.bin",
               vectors = 100, window = 12, iter = 5,
               threads = 8)

# If you've already trained a model
ats_model <- read.binary.vectors("ats.bin")

write_vectors <- function(model, out_basename) {
  stopifnot(is.matrix(model) || inherits(model, "VectorSpaceModel"))
  if (inherits(model, "VectorSpaceModel")) {
    model <- model@.Data
  }
  model_df <- as.data.frame(model)
  readr::write_tsv(model_df, paste0(out_basename, ".vectors"))
  readr::write_lines(rownames(model), paste0(out_basename, ".metadata"))
  return(invisible(NULL))
}

write_vectors(ats_model, "ats_model")

# Upload those files to http://projector.tensorflow.org/

# Try these exploratory functions
closest_to(ats_model, ats_model[[c("salvation", "saved")]])
closest_to(ats_model, ats_model[[c("mediator", "mediation")]])

death1 <- ats_model[["death"]] %>%
  reject(ats_model[[c("illness", "sick", "disease")]])

death2 <- ats_model[["death"]] %>%
  reject(ats_model[["eternal", "resurrection", "grace", "redeemed",
                    "redemption", "everlasting", "infinite"]])

closest_to(ats_model, death1)
closest_to(ats_model, death2)

death_sim1 <- cosineSimilarity(ats_model, death1) %>%
  as.data.frame() %>%
  rownames_to_column() %>%
  rename(word = rowname, death1 = V1)

death_sim2 <- cosineSimilarity(ats_model, death2) %>%
  as.data.frame() %>%
  rownames_to_column() %>%
  rename(word = rowname, death2 = V1)

sim_cf <- left_join(death_sim1, death_sim2, by ="word") %>%
  filter(abs(death1 - death2) > 0.25)
  # sample_n(100)

ggplot(sim_cf, aes(death1, death2)) +
  geom_point() +
  geom_text_repel(aes(label = word)) +
  geom_hline(yintercept = 0) +
  geom_vline(xintercept = 0)
