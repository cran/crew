crew_test("valid monad from crew_eval()", {
  monad <- crew_eval(quote(1L + 1L), name = "x")
  expect_silent(monad_validate(monad))
})

crew_test("keep track of seconds", {
  monad <- crew_eval(quote(1L + 1L), name = "x")
  out <- monad$seconds
  expect_true(is.numeric(out))
  expect_equal(length(out), 1L)
})

crew_test("run without error", {
  monad <- crew_eval(quote(1L + 1L), name = "x")
  expect_equal(monad$result, list(2L))
  expect_true(anyNA(monad$error))
  expect_true(anyNA(monad$trace))
})

crew_test("run with error", {
  monad <- crew_eval(quote(stop(12345)), name = "x")
  expect_equal(monad$result, list(NA))
  expect_true(any(grepl("12345", monad$error)))
  expect_true(any(grepl("12345", monad$trace)))
})

crew_test("error with no message", {
  monad <- crew_eval(quote(stop()), name = "x")
  expect_equal(monad$result, list(NA))
  expect_equal(monad$error, ".")
  expect_true(is.character(monad$trace))
  expect_true(length(monad$trace) > 0L)
  expect_true(any(nzchar(monad$trace)))
})

crew_test("run with warning, warning recorded", {
  skip_on_cran()
  monad <- crew_eval(quote(warning("12345")), name = "x")
  expect_true(any(grepl("12345", monad$warnings)))
})

crew_test("warning with no message, warning recorded", {
  skip_on_cran()
  monad <- crew_eval(quote(warning()), name = "x")
  expect_equal(monad$warnings, ".")
})

crew_test("warning character limit", {
  skip_on_cran()
  monad <- crew_eval(
    quote(
      lapply(
        seq_len(1e3),
        function(i) warning(paste(rep("a", 65), collapse = ""))
      )
    ),
    name = "x"
  )
  expect_equal(nchar(monad$warnings), crew_eval_max_nchar)
})

crew_test("encoding issue error handling", {
  skip_on_cran()
  monad <- crew_eval(
    quote(warning("<<\"pT\xbf\xbfD\x80QY\x94C\xd1")), name = "x"
  )
  expect_true(grepl("text encoding issue", monad$warnings))
})

crew_test("crew_eval() seed and algorithm", {
  skip_on_cran()
  old_algorithm <- RNGkind()[1L]
  old_seed <- .subset2(.GlobalEnv, ".Random.seed")
  out1 <- crew_eval(
    quote(sample.int(n = 1e9L, size = 1L)),
    seed = 1L,
    algorithm = "Super-Duper",
    name = "x"
  )
  out2 <- crew_eval(
    quote(sample.int(n = 1e9L, size = 1L)),
    seed = 1L,
    algorithm = "Super-Duper",
    name = "x"
  )
  out3 <- crew_eval(
    quote(sample.int(n = 1e9L, size = 1L)),
    seed = 2L,
    algorithm = "Super-Duper",
    name = "x"
  )
  expect_equal(out1$seed, 1L)
  expect_equal(out2$seed, 1L)
  expect_equal(out3$seed, 2L)
  expect_equal(out1$result[[1]], out2$result[[1]])
  expect_true(abs(out1$result[[1]] - out3$result[[1]]) > 1L)
  expect_equal(RNGkind()[1L], old_algorithm)
  expect_equal(.subset2(.GlobalEnv, ".Random.seed"), old_seed)
})

crew_test("crew_eval() just seed", {
  skip_on_cran()
  old_algorithm <- RNGkind()[1L]
  old_seed <- .subset2(.GlobalEnv, ".Random.seed")
  out1 <- crew_eval(
    quote(sample.int(n = 1e9L, size = 1L)),
    seed = 1L,
    algorithm = NULL,
    name = "x"
  )
  out2 <- crew_eval(
    quote(sample.int(n = 1e9L, size = 1L)),
    seed = 1L,
    algorithm = NULL,
    name = "x"
  )
  out3 <- crew_eval(
    quote(sample.int(n = 1e9L, size = 1L)),
    seed = 2L,
    algorithm = NULL,
    name = "x"
  )
  expect_equal(out1$seed, 1L)
  expect_equal(out2$seed, 1L)
  expect_equal(out3$seed, 2L)
  expect_equal(out1$result[[1]], out2$result[[1]])
  expect_true(abs(out1$result[[1]] - out3$result[[1]]) > 1L)
  expect_equal(RNGkind()[1L], old_algorithm)
  expect_equal(.subset2(.GlobalEnv, ".Random.seed"), old_seed)
})

crew_test("crew_eval() just algorithm", {
  skip_on_cran()
  old_algorithm <- RNGkind()[1L]
  old_seed <- .subset2(.GlobalEnv, ".Random.seed")
  out1 <- crew_eval(
    quote(sample.int(n = 1e9L, size = 1L)),
    seed = NULL,
    algorithm = "Super-Duper",
    name = "x"
  )
  out2 <- crew_eval(
    quote(sample.int(n = 1e9L, size = 1L)),
    seed = NULL,
    algorithm = "Super-Duper",
    name = "x"
  )
  out3 <- crew_eval(
    quote(sample.int(n = 1e9L, size = 1L)),
    seed = NULL,
    algorithm = "Super-Duper",
    name = "x"
  )
  expect_equal(RNGkind()[1L], old_algorithm)
  expect_equal(.subset2(.GlobalEnv, ".Random.seed"), old_seed)
})

crew_test("crew_eval() RNG state not restored if not set", {
  skip_on_cran()
  old_algorithm <- RNGkind()[1L]
  old_seed <- .subset2(.GlobalEnv, ".Random.seed")
  out1 <- crew_eval(
    quote(sample.int(n = 1e9L, size = 1L)),
    seed = NULL,
    algorithm = NULL,
    name = "x"
  )
  out2 <- crew_eval(
    quote(sample.int(n = 1e9L, size = 1L)),
    seed = NULL,
    algorithm = NULL,
    name = "x"
  )
  out3 <- crew_eval(
    quote(sample.int(n = 1e9L, size = 1L)),
    seed = NULL,
    algorithm = NULL,
    name = "x"
  )
  expect_false(all(.subset2(.GlobalEnv, ".Random.seed") == old_seed))
})

crew_test("crew_eval() environment variables", {
  skip_on_cran()
  envvars <- c("CREW_CONTROLLER", "CREW_WORKER")
  previous <- Sys.getenv(envvars)
  Sys.unsetenv(envvars)
  on.exit(do.call(what = Sys.setenv, args = as.list(previous)))
  out <- crew_eval(quote(L), name = "x")
  expect_equal(out$controller, NA_character_)
  expect_equal(out$worker, NA_character_)
  Sys.setenv(CREW_CONTROLLER = "x1", CREW_WORKER = "x2")
  out <- crew_eval(quote(L), name = "x")
  expect_equal(out$controller, "x1")
  expect_equal(out$worker, "x2")
})
