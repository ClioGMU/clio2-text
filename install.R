# Run these one at a time to make sure they install successfully

# Essential
install.packages("quanteda")
install.packages("readtext")

# Less essential
install.packages("tokenizers")
install.packages("stopwords")
install.packages("cleanNLP")
install.packages("stm")

# Run these to get sample corpora
library(remotes)
remotes::install_github("lmullen/WPAnarratives") # WPA former slave narratives
remotes::install_github("lmullen/tractarian") # Tracts for the Times
