library(quanteda)
library(readtext)
library(stringr)

ats_df <- readtext("ats")
ats <- corpus(ats_df)

summary(ats, 10)
texts(ats)[8]

kwic(ats, "religion")
kwic(ats, "religi*", valuetype = "glob")
kwic(ats, "religions?", valuetype = "regex")

docs <- c(dylan = "How many roads must a man walk down, before you'll call him a man?",
          cash  = "You can run on for a long time, sooner or later God will cut you down.") %>%
  str_to_lower()

tokens(docs)
tokens(docs, remove_punct = TRUE, remove_symbols = TRUE)
tokens(docs, ngrams = 2, remove_punct = TRUE, remove_symbols = TRUE)
tokens(docs, ngrams = 3, remove_punct = TRUE, remove_symbols = TRUE)
tokens(docs, ngrams = c(1, 3), skip = 2, remove_punct = TRUE, remove_symbols = TRUE)

ats_dfm <- dfm(ats, remove_punct = TRUE, remove_symbols = TRUE)
ats_dfm

ats_dfm[1:5, 1:10]

ats_dfm <- dfm(ats, remove_punct = TRUE, remove_symbols = TRUE,
               remove = stopwords("en"))

ats_dfm[1:5, 1:10]

View(ats_dfm[, 1:100])

topfeatures(ats_dfm, 20)

dictionary <- dictionary(list(
  conversion = c("saved", "salvation", "conversion", "convert", "redeem"),
  sin        = c("sin", "sinful", "wicked", "rebellious", "satan"),
  alcohol    = c("drink", "liquour", "beer", "spirits", "drunk", "drunken", "drunkard")
))

ats_dfm_dict <- dfm(ats, dictionary = dictionary, remove_punct = TRUE, remove_symbols = TRUE)
ats_dfm_dict

ats_dfm_prop <- ats_dfm %>% dfm_weight(scheme = "prop")
ats_dfm_prop[1:5, 1:5]

ats_dfm_tfidf <- ats_dfm %>% dfm_tfidf()
ats_dfm_tfidf[1:5, 1:5]
topfeatures(ats_dfm_tfidf, 100)

textstat_frequency(ats_dfm) %>% head(10)
textplot_xray(kwic(ats, "religion"))
textplot_xray(kwic(ats, "alcohol"))

keyness <- textstat_keyness(ats_dfm, target = "101202732.nlm.nih.gov.txt")
keyness %>% head()
textplot_keyness(keyness)
