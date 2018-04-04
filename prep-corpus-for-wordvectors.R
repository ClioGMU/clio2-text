library(WPAnarratives)
library(tidyverse)
library(wordVectors)

dir.create("wpa", showWarnings = FALSE)
walk2(wpa_narratives$text, str_c("wpa/", wpa_narratives$filename),
      readr::write_file)

prep_word2vec(origin = "wpa", destination = "wpa.corpus",
              lowercase = TRUE)
