#!/usr/bin/env Rscript

# get input
input <- jsonlite::fromJSON("input.json", flatten = FALSE)
input <- as.numeric(input)

# function
A <- function(x) x^2

# output (it is important set the output as JSON)
jsonlite::toJSON(list(side = input, area = A(input)), auto_unbox = TRUE)
