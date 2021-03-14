#!/usr/bin/env Rscript

# get input
args <- commandArgs(trailingOnly=TRUE)

# function
A <- function(x) x^2

# input
x <- as.numeric(args[1])

# output (it is important set the output as JSON)
cat(jsonlite::toJSON(list(side = x, area = A(x)), auto_unbox = TRUE))
