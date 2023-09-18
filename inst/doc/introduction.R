## ---- include = FALSE---------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>",
  eval = FALSE
)
library(crew)

## -----------------------------------------------------------------------------
#  library(crew)
#  controller <- crew_controller_local(
#    name = "example",
#    workers = 2,
#    seconds_idle = 10
#  )

## -----------------------------------------------------------------------------
#  controller$start()

## -----------------------------------------------------------------------------
#  controller$push(name = "get pid", command = ps::ps_pid())

## -----------------------------------------------------------------------------
#  controller$pop() # No workers started yet and the task is not done.
#  #> NULL
#  
#  task <- controller$pop() # Worker started, task complete.
#  task
#  #> # A tibble: 1 × 12
#  #>   name    command result seconds  seed algorithm error trace warnings
#  #>   <chr>   <chr>   <list>   <dbl> <int> <chr>     <chr> <chr> <chr>
#  #> 1 get pid NA      <int>        0    NA NA        NA    NA    NA
#  #> # ℹ 3 more variables: launcher <chr>, worker <int>, instance <chr>

## -----------------------------------------------------------------------------
#  controller$wait(mode = "all")

## -----------------------------------------------------------------------------
#  task$result[[1]] # return value of the task
#  #> [1] 69631

## -----------------------------------------------------------------------------
#  results <- controller$map(
#    command = a + b + c + d,
#    iterate = list(
#      a = c(1, 3),
#      b = c(2, 4)
#    ),
#    data = list(c = 5),
#    globals = list(d = 6)
#  )
#  
#  results
#  #> # A tibble: 2 × 12
#  #>   name  command result    seconds  seed algorithm error trace warnings
#  #>   <chr> <chr>   <list>      <dbl> <int> <chr>     <chr> <chr> <chr>
#  #> 1 1     NA      <dbl [1]>       0    NA NA        NA    NA    NA
#  #> 2 2     NA      <dbl [1]>       0    NA NA        NA    NA    NA
#  #> # ℹ 3 more variables: launcher <chr>, worker <int>, instance <chr>
#  
#  as.numeric(results$result)
#  #> [1] 14 18

## -----------------------------------------------------------------------------
#  controller$summary()
#  #> # A tibble: 2 × 6
#  #>   controller worker tasks seconds errors warnings
#  #>   <chr>       <int> <int>   <dbl>  <int>    <int>
#  #> 1 example         1     2   0.001      0        0
#  #> 2 example         2     1   0          0        0

## -----------------------------------------------------------------------------
#  controller$schedule$summary()
#  #> # A tibble: 1 × 2
#  #>   pushed collected
#  #>    <int>     <int>
#  #> 1      0         0

## -----------------------------------------------------------------------------
#  controller$launcher$summary()
#  #> # A tibble: 2 × 4
#  #>   worker launches assigned complete
#  #>    <int>    <int>    <int>    <int>
#  #> 1      1        2        1        1
#  #> 2      2        1        0        0

## -----------------------------------------------------------------------------
#  controller$client$summary()
#  #> # A tibble: 2 × 6
#  #>   worker online instances assigned complete socket
#  #>    <int> <lgl>      <int>    <int>    <int> <chr>
#  #> 1      1 FALSE          1        2        2 ws://10.0.0.32:58685/1/15e07250…
#  #> 2      2 FALSE          1        1        1 ws://10.0.0.32:58685/2/cb45b3d4…

## -----------------------------------------------------------------------------
#  controller$terminate()

## -----------------------------------------------------------------------------
#  crew_clean()
#  #> nothing to clean up

