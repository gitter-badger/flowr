## ---- echo = FALSE, message = FALSE--------------------------------------
library(knitr)
knitr::opts_chunk$set(
  comment = "#>",
  error = FALSE,
  tidy = FALSE,
	fig.cap = ""
)
library(flowr)


## ----echo=FALSE----------------------------------------------------------
exdata = file.path(system.file(package = "flowr"), "misc")
plat <- read_sheet(file.path(exdata, "platforms_supported.txt"), id_column = "Platform")
kable(plat)

