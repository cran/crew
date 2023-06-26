## ----setup, include = FALSE---------------------------------------------------
set.seed(0)
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>",
  paged.print = FALSE,
  eval = FALSE
)

## -----------------------------------------------------------------------------
#  library(crew)
#  persistent <- crew_controller_local(name = "persistent")
#  transient <- crew_controller_local(name = "semi-persistent", tasks_max = 4L)

## -----------------------------------------------------------------------------
#  group <- crew_controller_group(persistent, transient)

## -----------------------------------------------------------------------------
#  group$start()

## -----------------------------------------------------------------------------
#  group$push(name = "my task", command = sqrt(4), controller = "semi-persistent")

## -----------------------------------------------------------------------------
#  group$wait(controllers = "semi-persistent")
#  group$pop()
#  #> # A tibble: 1 × 11
#  #>   name    command result seconds   seed error trace warnings launcher worker
#  #>   <chr>   <chr>   <list>   <dbl>  <int> <chr> <chr> <chr>    <chr>     <int>
#  #> 1 my task NA      <dbl>        0 6.30e8 NA    NA    NA       semi-pe…      1
#  #> # ℹ 1 more variable: instance <chr>

## -----------------------------------------------------------------------------
#  group$summary()
#  #> # A tibble: 2 × 6
#  #>   controller      worker tasks seconds errors warnings
#  #>   <chr>            <int> <int>   <dbl>  <int>    <int>
#  #> 1 persistent           1     0       0      0        0
#  #> 2 semi-persistent      1     1       0      0        0

## -----------------------------------------------------------------------------
#  group$terminate()

