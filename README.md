# Clio 2: Text analysis

Your assignment is to apply a text analysis method to a corpus of your choice. You may use the WPA former slave narratives or the *Tracts for the Times* corpora provided, or you may find your own corpus. If you want to use the ATS corpus for some method other than topic modeling, ask me for a slightly larger sample. Note that it is not necessary to use a very large corpus. 

You should start by applying a term-frequency and TF-IDF analysis to your corpus. Then you should also analyze the corpus using either topic modeling (the tidytext plus stm packages), named entity recognition (the cleanNLP package), sentiment analysis (tidytext), word vectors (either the wordVectors or the text2vec package), or text reuse (the textreuse pacakge). Read the documentation for those packages, especially the vignettes if they have any. The quanteda package also contains a number of [sample analyses](https://tutorials.quanteda.io/).

You should turn in a brief essay that includes several visualizations and 500 or sowords of prose. The prose and visualizations should combine to make some historically meaningful interpretation or exploration of your corpus. Your visualizations should be of presentation quality. Include the code blocks, which should contain only the code necessary to generate the figures. Turn in both your R Markdown file and the HTML notebook to Dropbox.

## Things to known

- `install.R` will help you install the key packages
- `demo.R` will show you how to do basic analyses.
- `assignment.Rmd` is a template for the assignment
- `ats/` contains 20 sample tracts printed by the American Tract Society
