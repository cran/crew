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
#  group$map(
#    command = a + b + c + d,
#    iterate = list(
#      a = c(1, 3),
#      b = c(2, 4)
#    ),
#    data = list(c = 5),
#    globals = list(d = 6),
#    controller = "persistent"
#  )
#  #> # A tibble: 2 × 11
#  #>   name  command result    seconds      seed error trace warnings
#  #>   <chr> <chr>   <list>      <dbl>     <int> <chr> <chr> <chr>
#  #> 1 1     NA      <dbl [1]>       0 870591596 NA    NA    NA
#  #> 2 2     NA      <dbl [1]>       0 870591595 NA    NA    NA
#  #> # ℹ 3 more variables: launcher <chr>, worker <int>,
#  #> #   instance <chr>

## -----------------------------------------------------------------------------
#  group$summary()
#  #> # A tibble: 2 × 6
#  #>   controller      worker tasks seconds errors warnings
#  #>   <chr>            <int> <int>   <dbl>  <int>    <int>
#  #> 1 persistent           1     2       0      0        0
#  #> 2 semi-persistent      1     1       0      0        0

## -----------------------------------------------------------------------------
#  group$terminate()

