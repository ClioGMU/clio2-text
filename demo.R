# Demo of text analysis techniques
# ------------------------------------------------------------
library(tidyverse)
library(stringr)

# Load a corpus from a package
# ------------------------------------------------------------
library(WPAnarratives)
data("wpa_narratives")

library(tractarian)
data("tracts_for_the_times")

# Load a set of text files in a directory
# ------------------------------------------------------------
library(readtext)
# `ats` is the name of the directory containing text
ats <- readtext("ats/*") %>% as_tibble()


# Turn text into tokens
# ------------------------------------------------------------
doc <- ats[1, "text"]

library(tokenizers)
library(stopwords)

doc %>% tokenize_words(simplify = TRUE) %>% head(100)
doc %>% tokenize_words(simplify = TRUE, stopwords = stopwords("en")) %>% head(100)

# Try running this to see all the functions in the tokenizers package.
# What do the different tokenizers output?
help(package="tokenizers")

# Create a data frame of words using tidytext
# ------------------------------------------------------------
library(tidytext)
ats_words <- ats %>% unnest_tokens(word, text, token = "words")

# Can you create a document with 3-grams?

# Get the 20 most commonly used words
# ------------------------------------------------------------
ats_words %>%
  count(word) %>%
  top_n(20)

# How would you get the most commonly used words in each document?

# Using stopwords with tidy text
# ------------------------------------------------------------
ats_clean_words <- ats_words %>%
  anti_join(stop_words) %>%
  filter(!str_detect(word, "^\\d+$")) %>%
  filter(!(word %in% c("ing")))

ats_clean_words %>%
  count(word, sort = TRUE) %>%
  top_n(20)

# What are the top words in each document?

# TF-IDF
# ------------------------------------------------------------
doc_words <- ats_clean_words %>%
  group_by(doc_id) %>%
  count(word) %>%
  ungroup()

corpus_words <- doc_words %>%
  group_by(doc_id) %>%
  summarize(total = sum(n))

doc_words <- doc_words %>%
  left_join(corpus_words)

ggplot(doc_words, aes(n/total, fill = doc_id)) +
  geom_histogram(show.legend = FALSE, bins = 100) +
  xlim(NA, 0.01) +
  facet_wrap(~doc_id, ncol = 2, scales = "free_y")

freq_by_rank <- doc_words %>%
  group_by(doc_id) %>%
  mutate(rank = row_number(),
         term_frequency = n/total)


# "The idea of tf-idf is to find the important words for the content of each
# document by decreasing the weight for commonly used words and increasing the
# weight for words that are not used very much in a collection or corpus of
# documents, in this case, the group of Jane Austen’s novels as a whole.
# Calculating tf-idf attempts to find the words that are important (i.e.,
# common) in a text, but not too common."
doc_words %>%
  bind_tf_idf(word, doc_id, n) %>%
  group_by(doc_id) %>%
  top_n(10, tf_idf) %>%
  arrange(doc_id, desc(tf_idf))

# Look at the actual text files. Was TF-IDF useful for guessing their subjects?

# Topic models
# ------------------------------------------------------------
library(stm)
library(Matrix)

ats_dtm <- doc_words %>%
  cast_sparse(doc_id, word, n)

ats_dtm[1:10, 1:5]

# Only doing this on 3 documents for speed purposes. You would normally skip
# these steps.
ats_small_dtm <- ats_dtm[1:3, ]
ats_small_dtm <- ats_small_dtm[ , colSums(ats_small_dtm) > 0]
dim(ats_dtm)
dim(ats_small_dtm)

# This step can take a long time.
# K is the number of topics.
# Seed makes sure we get the same results each time.
topic_model <- stm(ats_small_dtm, K = 3, verbose = TRUE, seed = 832)

# Beta is the relationship of terms to topics
td_beta <- tidy(topic_model, matrix = "beta")

# Gamma is the relationship of documents to topics
td_gamma <- tidy(topic_model, matrix = "gamma",
                 document_names = rownames(ats_small_dtm))

# Examine the topics
td_beta %>%
  group_by(topic) %>%
  top_n(10, beta) %>%
  ungroup() %>%
  ggplot(aes(term, beta)) +
  geom_col() +
  facet_wrap(~ topic, scales = "free") +
  coord_flip()

# tidy the document-topic combinations, with optional document names
td_gamma <- tidy(topic_model, matrix = "gamma",
                 document_names = rownames(ats_small_dtm))
td_gamma %>%
  mutate(gamma = round(gamma, 6)) %>%
  arrange(document, desc(gamma))

# Try running this on a whole corpus and set K to less than the number of documents.


