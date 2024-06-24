## ----include = FALSE----------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)
library(crew)

## -----------------------------------------------------------------------------
library(crew)
launcher <- crew_launcher_local()
launcher$call(
  socket = "ws://127.0.0.1:5000/3/aa9c59ea",
  launcher = "my_launcher",
  worker = 3L,
  instance = "aa9c59ea"
)

