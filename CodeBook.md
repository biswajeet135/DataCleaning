---
title: "CodeBook.md"
author: "Biswajeet Sahoo"
date: "September 24, 2017"
output: html_document
---

```{r setup, include=FALSE}
knitr::opts_chunk$set(echo = TRUE)
```

# Introduction

The script `run_analysis.R`performs the 5 steps described in the course project's definition.

* First, all the similar data is merged using the `rbind()` function. By similar, we address those files having the same number of columns and referring to the same entities.
* Then, only those columns with the mean and standard deviation measures are taken from the whole dataset. After extracting these columns, they are given the correct names, taken from `features.txt`.
* As activity data is addressed with values 1:6, we take the activity names and IDs from `activity_labels.txt` and they are substituted in the dataset.
* On the whole dataset, those columns with vague column names are corrected.
* Finally, we generate a new dataset with all the average measures for each subject and activity type (30 subjects * 6 activities = 180 rows). The output file is called `averages_data.txt`, and uploaded to this repository.

# Variables

* `trainingSubjects`, `trainingValues`, `trainingValues`, `testSubjects`, `testValues` and `testActivity` contain the data from the downloaded files.
* `features` contains the correct names for the dataset, which are applied to the column names 
* A similar approach is taken with activity names through the `activities` variable.
* `usefulcolumns` contains columns for mean and standard deviation, which is later used to filter only useful columns.
* Finally, `finaldataMeans` contains the relevant averages which will be later stored in a `.txt` file.