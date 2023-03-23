## ---- include = FALSE---------------------------------------------------------
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
#      launch_worker = function(socket, host, port, token, name) {
#        call <- self$call(socket, host, port, token, name)
#        processx::process$new(command = "R", args = c("-e", call))
#      },
#      terminate_worker = function(handle) {
#        handle$kill()
#      }
#    )
#  )

## -----------------------------------------------------------------------------
#  call <- self$call(socket, host, port, token, name)

## -----------------------------------------------------------------------------
#  launcher <- crew::crew_launcher_callr()
#  launcher$call(
#    socket = "ws://127.0.0.1:5000",
#    host = "127.0.0.1",
#    port = "5711",
#    token = "my_token",
#    name = "my_name"
#  )
#  #> [1] "crew::crew_worker(token = \"my_token\", host = \"127.0.0.1\", port = \"5711\", settings = list(url = \"ws://127.0.0.1:5000\", asyncdial = TRUE, maxtasks = Inf, idletime = Inf, walltime = Inf, timerstart = 0L, exitlinger = 100, cleanup = FALSE))"

## -----------------------------------------------------------------------------
#  processx::process$new(command = "R", args = c("-e", call))

## -----------------------------------------------------------------------------
#  terminate_worker = function(handle) {
#    handle$kill()
#  }

## -----------------------------------------------------------------------------
#  #' @title Create a controller with the custom launcher.
#  #' @export
#  #' @description Create an `R6` object to submit tasks and
#  #'   launch workers.
#  #' @inheritParams crew::crew_controller_callr
#  crew_controller_custom <- function(
#    name = "custom controller name",
#    workers = 1L,
#    host = NULL,
#    port = NULL,
#    seconds_launch = 30,
#    seconds_interval = 0.001,
#    seconds_timeout = 5,
#    seconds_idle = Inf,
#    seconds_wall = Inf,
#    seconds_exit = 1,
#    tasks_max = Inf,
#    tasks_timers = 0L,
#    async_dial = TRUE,
#    cleanup = FALSE,
#    auto_scale = "demand"
#  ) {
#    router <- crew::crew_router(
#      name = name,
#      workers = workers,
#      host = host,
#      port = port,
#      seconds_interval = seconds_interval,
#      seconds_timeout = seconds_timeout
#    )
#    launcher <- custom_launcher_class$new(
#      name = name,
#      seconds_launch = seconds_launch,
#      seconds_interval = seconds_interval,
#      seconds_timeout = seconds_timeout,
#      seconds_idle = seconds_idle,
#      seconds_wall = seconds_wall,
#      seconds_exit = seconds_exit,
#      tasks_max = tasks_max,
#      tasks_timers = tasks_timers,
#      async_dial = async_dial,
#      cleanup = cleanup
#    )
#    controller <- crew::crew_controller(
#      router = router,
#      launcher = launcher,
#      auto_scale = auto_scale
#    )
#    controller$validate()
#    controller
#  }

## -----------------------------------------------------------------------------
#  library(crew)
#  crew_session_start()

## -----------------------------------------------------------------------------
#  controller <- crew_controller_custom(workers = 2)
#  controller$start()

## -----------------------------------------------------------------------------
#  controller$push(
#    name = "get worker IP address and process ID",
#    command = paste(getip::getip(type = "local"), ps::ps_pid())
#  )

## -----------------------------------------------------------------------------
#  controller$wait()
#  out <- controller$pop()
#  out$result[[1]]
#  #> [1] "192.168.0.2 27336"

## -----------------------------------------------------------------------------
#  getip::getip(type = "local")
#  #> "192.168.0.2"
#  controller$launcher$workers$handle[[1]]$get_pid()
#  #> [1] 27336

## -----------------------------------------------------------------------------
#  controller$summary(columns = starts_with("worker"))
#  #> # A tibble: 2 × 5
#  #>   worker_socket         worker_connected worker_busy worker_launches worker_instances
#  #>   <chr>                 <lgl>            <lgl>                 <int>            <int>
#  #> 1 ws://10.0.0.9:58805/1 TRUE             FALSE                     1                1
#  #> 2 ws://10.0.0.9:58805/2 FALSE            FALSE                     0                0

## -----------------------------------------------------------------------------
#  controller$terminate()

## -----------------------------------------------------------------------------
#  library(crew)
#  crew_session_start()
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
#  crew_wait(
#    ~all(controller$summary()$worker_connected == FALSE),
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
#  crew_wait(
#    ~all(controller$summary()$worker_connected == FALSE),
#    seconds_interval = 1,
#    seconds_timeout = 60
#  )
#  # Collect the results.
#  results <- NULL
#  while (!is.null(out <- controller$pop(scale = FALSE))) {
#    if (!is.null(out)) {
#      results <- dplyr::bind_rows(results, out)
#    }
#  }
#  # Check the results
#  all(sort(unlist(results$result)) == seq_len(200L))
#  #> [1] TRUE
#  length(unique(results$socket_session))
#  #> [1] 4
#  # View worker and task summaries.
#  View(controller$summary())
#  # Terminate the controller.
#  controller$terminate()
#  # Now outside crew, verify that the mirai dispatcher
#  # and crew workers successfully terminated.

