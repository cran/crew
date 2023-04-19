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
#  #>   name    command result seconds   seed error trace warni…¹ launc…² worker
#  #>   <chr>   <chr>   <list>   <dbl>  <int> <chr> <chr> <chr>   <chr>    <int>
#  #> 1 my task sqrt(4) <dbl>        0 5.11e8 NA    NA    NA      semi-p…      1
#  #> # … with 1 more variable: instance <chr>, and abbreviated variable names
#  #> #   ¹​warnings, ²​launcher

## -----------------------------------------------------------------------------
#  group$summary(columns = starts_with(c("controller", "tasks")))
#  #> # A tibble: 2 × 3
#  #>   controller     tasks_assigned tasks_complete
#  #>   <chr>                   <int>          <int>
#  #> 1 persistent                  0              0
#  #> 2 semi-persistent             1              1

## -----------------------------------------------------------------------------
#  group$terminate()

