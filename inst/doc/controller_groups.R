## ----setup, include = FALSE---------------------------------------------------
set.seed(0)
library(crew)
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>",
  paged.print = FALSE,
  eval = FALSE
)

## -----------------------------------------------------------------------------
#  persistent <- crew_controller_callr(name = "persistent")
#  transient <- crew_controller_callr(name = "semi-persistent", tasks_max = 4L)

## -----------------------------------------------------------------------------
#  group <- crew_controller_group(persistent, transient)

## -----------------------------------------------------------------------------
#  group$start()

## -----------------------------------------------------------------------------
#  group$push(name = "my task", command = sqrt(4), controller = "semi-persistent")

## -----------------------------------------------------------------------------
#  group$wait(controllers = "semi-persistent")
#  group$pop()
#  #> # A tibble: 1 × 7
#  #>   name    command result    seconds error traceback warnings
#  #>   <chr>   <chr>   <list>      <dbl> <chr> <chr>     <chr>
#  #> 1 my task sqrt(4) <dbl [1]>       0 NA    NA        NA

## -----------------------------------------------------------------------------
#  group$summary(columns = starts_with(c("controller", "tasks")))
#  #> # A tibble: 2 × 3
#  #>   controller     tasks_assigned tasks_complete
#  #>   <chr>                   <int>          <int>
#  #> 1 persistent                  0              0
#  #> 2 semi-persistent             1              1

## -----------------------------------------------------------------------------
#  group$terminate()

