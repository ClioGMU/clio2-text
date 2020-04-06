# stringr is useful for doing basic text processing

library(stringr)

sentence <- "The Civil War started in 1861 and ended in 1865."

str_to_lower(sentence)

str_detect(sentence, "war")
sentence %>% str_to_lower() %>% str_detect("war")
str_detect(sentence, "\\d{4}")

str_extract(sentence, "\\d{4}")
str_extract_all(sentence, "\\d{4}")

str_sub(sentence, 1, 10)
