# Cf. https://quanteda.io/articles/pkgdown/replication/text2vec.html

library(readtext)
library(quanteda)
library(stopwords)
library(text2vec)
library(tokenizers)
quanteda_options(threads = 4)

# Create the corpus
ats_df <- readtext("ats")
ats <- corpus(ats_df)

# Tokenize with a word tokenizer
ats_tokens <- ats_df$text %>% tokenize_words
names(ats_tokens) <- ats_df$doc_id

ats_tokens <- ats_tokens %>%
  tokens(remove_punct = TRUE, remove_symbols = TRUE, remove_numbers = TRUE)

ats_dfm <- dfm(ats_tokens, verbose = TRUE, tolower = TRUE,
               remove = stopwords(source = "stopwords-iso")) %>%
  dfm_trim(min_termfreq = 10)

# Keep only the words we want
ats_features <- ats_dfm %>% featnames()
ats_tokens_keep <- tokens_select(ats_tokens, ats_features,
                                 padding = TRUE, case_insensitive = TRUE)

# Constructure a term-co-occurence matrix
ats_tcm <- fcm(ats_tokens_keep, context = "window",
               count = "weighted", weights = 1 / (1:5),
               tri = TRUE)

# Fit a GloVe model
glove <- GlobalVectors$new(rank = 50, x_max = 10)
wv_main <- glove$fit_transform(ats_tcm, n_iter = 20,
                               convergence_tol = 0.01, n_threads = 4)

# Averaging out main and contextual representations
wv_context <- glove$components
word_vectors <- wv_main + t(wv_context)

# Helper function for getting an individual word vector
word <- function(wv, word) {
  wv[word, , drop = FALSE]
}

# Helper functions for getting most similar words
similarity <- function(wv, to) {
  textstat_simil(as.dfm(wv),
                 y = as.dfm(to),
                 margin = "documents",
                 method = "cosine")
}

closest <- function(sim_m, similarity = TRUE, n = 10) {
  head(sort(sim_m[, 1], decreasing = similarity), n)
}

# Individual word vectors
religion <- word_vectors %>% word("religion")
faith <- word_vectors %>% word("faith")
spiritual <- word_vectors %>% word("spiritual")
pride <- word_vectors %>% word("pride")
bible <- word_vectors %>% word("bible")
sad <- word_vectors %>% word("sad")
worship <- word_vectors %>% word("worship")

word_vectors %>% similarity(to = religion) %>% closest()
word_vectors %>% similarity(to = religion) %>% closest(similarity = FALSE)

word_vectors %>% similarity(to = religion - faith - spiritual) %>% closest()

word_vectors %>% similarity(to = pride) %>% closest()
word_vectors %>% similarity(to = bible) %>% closest()
word_vectors %>% similarity(to = bible - sad) %>% closest()
word_vectors %>% similarity(to = worship - bible) %>% closest()
