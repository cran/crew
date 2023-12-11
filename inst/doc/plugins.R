## ----include = FALSE----------------------------------------------------------
library(crew)
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>",
  eval = FALSE
)

## -----------------------------------------------------------------------------
#  custom_launcher_class <- R6::R6Class(
#    classname = "custom_launcher_class",
#    inherit = crew::crew_class_launcher,
#    public = list(
#      launch_worker = function(call, name, launcher, worker, instance) {
#        bin <- file.path(R.home("bin"), "R")
#        processx::process$new(
#          command = bin,
#          args = c("-e", call),
#          cleanup = FALSE
#        )
#      },
#      terminate_worker = function(handle) {
#        handle$kill()
#      }
#    )
#  )

## ----eval = TRUE, message = FALSE---------------------------------------------
library(crew)
launcher <- crew_launcher_local()
launcher$call(
  socket = "ws://127.0.0.1:5000/3/aa9c59ea",
  launcher = "my_launcher",
  worker = 3L,
  instance = "aa9c59ea"
)

## -----------------------------------------------------------------------------
#  #' @title Create a controller with the custom launcher.
#  #' @export
#  #' @description Create an `R6` object to submit tasks and
#  #'   launch workers.
#  #' @inheritParams crew::crew_controller_local
#  crew_controller_custom <- function(
#    name = "custom controller name",
#    workers = 1L,
#    host = NULL,
#    port = NULL,
#    tls = crew::crew_tls(),
#    seconds_interval = 0.5,
#    seconds_timeout = 30,
#    seconds_launch = 30,
#    seconds_idle = Inf,
#    seconds_wall = Inf,
#    tasks_max = Inf,
#    tasks_timers = 0L,
#    reset_globals = TRUE,
#    reset_packages = FALSE,
#    reset_options = FALSE,
#    garbage_collection = FALSE,
#    launch_max = 5L
#  ) {
#    client <- crew::crew_client(
#      name = name,
#      workers = workers,
#      host = host,
#      port = port,
#      tls = tls,
#      seconds_interval = seconds_interval,
#      seconds_timeout = seconds_timeout
#    )
#    launcher <- custom_launcher_class$new(
#      name = name,
#      seconds_interval = seconds_interval,
#      seconds_timeout = seconds_timeout,
#      seconds_launch = seconds_launch,
#      seconds_idle = seconds_idle,
#      seconds_wall = seconds_wall,
#      tasks_max = tasks_max,
#      tasks_timers = tasks_timers,
#      reset_globals = reset_globals,
#      reset_packages = reset_packages,
#      reset_options = reset_options,
#      garbage_collection = garbage_collection,
#      launch_max = launch_max,
#      tls = tls
#    )
#    controller <- crew::crew_controller(client = client, launcher = launcher)
#    controller$validate()
#    controller
#  }

## -----------------------------------------------------------------------------
#  library(crew)
#  controller <- crew_controller_custom(workers = 2)
#  controller$start()

## -----------------------------------------------------------------------------
#  controller$push(
#    name = "get worker IP address and process ID",
#    command = paste(getip::getip(type = "local"), ps::ps_pid())
#  )

## -----------------------------------------------------------------------------
#  controller$wait()
#  result <- controller$pop()
#  result$result[[1]]
#  #> [1] "192.168.0.2 27336"

## -----------------------------------------------------------------------------
#  getip::getip(type = "local")
#  #> "192.168.0.2"
#  controller$launcher$workers$handle[[1]]$get_pid()
#  #> [1] 27336

## -----------------------------------------------------------------------------
#  controller$client$summary()
#  #> # A tibble: 2 × 6
#  #>   worker online instances assigned complete socket
#  #>    <int> <lgl>      <int>    <int>    <int> <chr>
#  #> 1      1 TRUE           1        1        1 ws://10.0.0.32:50258/1/571bcda7…
#  #> 2      2 FALSE          0        0        0 ws://10.0.0.32:50258/2/daf88d6e…

## -----------------------------------------------------------------------------
#  controller$terminate()

## -----------------------------------------------------------------------------
#  library(crew)
#  controller <- crew_controller_custom(
#    seconds_idle = 2L,
#    workers = 2L
#  )
#  controller$start()
#  # Push 100 tasks
#  for (index in seq_len(100L)) {
#    name <- paste0("task_", index)
#    controller$push(name = name, command = index, data = list(index = index))
#    message(paste("push", name))
#  }
#  # Wait for the tasks to complete.
#  controller$wait()
#  # Wait for the workers to idle out and exit on their own.
#  crew_retry(
#    ~all(controller$client$summary()$online == FALSE),
#    seconds_interval = 1,
#    seconds_timeout = 60
#  )
#  # Do the same for 100 more tasks.
#  for (index in (seq_len(100L) + 100L)) {
#    name <- paste0("task_", index)
#    controller$push(name = name, command = index, data = list(index = index))
#    message(paste("push", name))
#  }
#  controller$wait()
#  crew_retry(
#    ~all(controller$client$summary()$online == FALSE),
#    seconds_interval = 1,
#    seconds_timeout = 60
#  )
#  # Collect the results.
#  results <- NULL
#  while (!is.null(result <- controller$pop(scale = FALSE))) {
#    if (!is.null(result)) {
#      results <- dplyr::bind_rows(results, result)
#    }
#  }
#  # Check the results
#  all(sort(unlist(results$result)) == seq_len(200L))
#  #> [1] TRUE
#  # View worker and task summaries.
#  controller$summary()
#  controller$schedule$summary()
#  controller$launcher$summary()
#  controller$schedule$summary()
#  # Terminate the controller.
#  controller$terminate()
#  # Now outside crew, verify that the mirai dispatcher
#  # and crew workers successfully terminated.

## -----------------------------------------------------------------------------
#  async_launcher_class <- R6::R6Class(
#    classname = "custom_launcher_class",
#    inherit = crew::crew_class_launcher,
#    public = list(
#      launch_worker = function(call, name, launcher, worker, instance) {
#        self$async$eval(
#          command = list(pid = process$new(bin, args = c("-e", call))$get_pid()),
#          data = list(bin = file.path(R.home("bin"), "R"), call = call),
#          packages = "processx"
#        )
#      },
#      terminate_worker = function(handle) {
#        self$async$eval(
#          command = ps::ps_kill(p = ps::ps_handle(pid = pid)),
#          data = list(pid = handle$data$pid)
#        )
#      }
#    )
#  )

## -----------------------------------------------------------------------------
#  crew_controller_async <- function(
#    name = "async controller name",
#    workers = 1L,
#    host = "127.0.0.1",
#    port = NULL,
#    tls = crew::crew_tls(mode = "none"),
#    seconds_interval = 0.5,
#    seconds_timeout = 30,
#    seconds_launch = 30,
#    seconds_idle = Inf,
#    seconds_wall = Inf,
#    tasks_max = Inf,
#    tasks_timers = 0L,
#    reset_globals = TRUE,
#    reset_packages = FALSE,
#    reset_options = FALSE,
#    garbage_collection = FALSE,
#    launch_max = 5L,
#    processes = NULL # Number of local async daemons for worker launches etc.
#  ) {
#    client <- crew::crew_client(
#      name = name,
#      workers = workers,
#      host = host,
#      port = port,
#      tls = tls,
#      seconds_interval = seconds_interval,
#      seconds_timeout = seconds_timeout
#    )
#    launcher <- async_launcher_class$new(
#      name = name,
#      seconds_interval = seconds_interval,
#      seconds_launch = seconds_launch,
#      seconds_idle = seconds_idle,
#      seconds_wall = seconds_wall,
#      tasks_max = tasks_max,
#      tasks_timers = tasks_timers,
#      reset_globals = reset_globals,
#      reset_packages = reset_packages,
#      reset_options = reset_options,
#      garbage_collection = garbage_collection,
#      launch_max = launch_max,
#      tls = tls,
#      processes = processes
#    )
#    controller <- crew::crew_controller(
#      client = client,
#      launcher = launcher
#    )
#    controller$validate()
#    controller
#  }

## -----------------------------------------------------------------------------
#  async_controller <- crew_controller_async(workers = 12, processes = 4)

