library(tidyverse)
library(quanteda)
library(readtext)
library(stm)
library(Matrix)
library(broom)
library(LDAvis)

# Read in the texts
my_texts <- readtext("ats/*") %>%
  as_tibble() %>%
  sample_n(3) # Remove this line to do this for all the documents, not just three.

# Create the corpus
my_corpus <- corpus(my_texts)

# Create the document feature matrix
my_dfm <- dfm(my_corpus,
              remove_punct = TRUE,
              remove_symbols = TRUE,
              remove = c(stopwords("en"), as.character(1:100)))

# Train the topic model
# This step can take a long time.
# K is the number of topics.
# Seed makes sure we get the same results each time.
topic_model <- stm(my_dfm, K = 3, verbose = TRUE, seed = 832)

# Look at the summary
summary(topic_model)

# Get the words
labelTopics(topic_model, n = 20)

# Get the documents
findThoughts(topic_model, texts = docnames(my_corpus))

# Plot it
plot(topic_model)
plot(topic_model, type = "labels")

# Topic correlation
cor <- topicCorr(topic_model)
cor$cor
plot(cor)

# LDA viz
processed <- textProcessor(my_texts$text)
out <- prepDocuments(processed$documents, processed$vocab, processed$meta)
docs <- out$documents
toLDAvis(topic_model, docs = docs)
