# Run these one at a time to make sure they install successfully

install.packages("tokenizers")
install.packages("textreuse")
install.packages("stopwords")
install.packages("text2vec")
install.packages("cleanNLP")
install.packages("quanteda")
install.packages("tidytext")
install.packages("readtext")
install.packages("stm")

# Run these to get sample corpora
devtools::install_github("lmullen/WPAnarratives") # WPA former slave narratives
devtools::install_github("lmullen/tractarian") # Tracts for the Times

data("wpa_narratives")
data("tracts_for_the_times")
