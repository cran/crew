% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/crew_client.R
\name{crew_client}
\alias{crew_client}
\title{Create a client object.}
\usage{
crew_client(
  name = NULL,
  workers = 1L,
  host = NULL,
  port = NULL,
  tls_enable = FALSE,
  tls_config = NULL,
  seconds_interval = 0.25,
  seconds_timeout = 10
)
}
\arguments{
\item{name}{Name of the client object. If \code{NULL}, a name is automatically
generated.}

\item{workers}{Integer, maximum number of parallel workers to run.}

\item{host}{IP address of the \code{mirai} client to send and receive tasks.
If \code{NULL}, the host defaults to the local IP address.}

\item{port}{TCP port to listen for the workers. If \code{NULL},
then an available ephemeral port is automatically chosen.}

\item{tls_enable}{Logical of length 1, whether to use transport layer
security (TLS) to secure connections between the client and workers.
Only supported for \code{mirai} version 0.9.0.9020 and above and
\code{nanonext} version 0.9.0.9034 and above.
Uses an automatically generated one-time self-signed certificate by
default. To guard against man-in-the-middle attacks, consider
generating a one-time certificate yourself, requesting a trusted
certificate authority (CA) to sign it, and then supplying the
keys to the \code{tls_config} argument. Enabling TLS requires \code{mirai}
version 0.9.0.9013 or above, and a \code{NULL} value for \code{tls_enable}
will enable TLS if and only if the \code{mirai} version is sufficient.}

\item{tls_config}{Optional and only relevant if TLS is enabled
(see the \code{tls_config} argument). The \code{tls_config} argument
controls how transport layer security (TLS) is configured,
and it is directly forwarded to the \code{tls} argument of
\code{mirai::daemons()}. If \code{tls_config} is \code{NULL},
then \code{mirai} will generate a one-time
self-signed certificate. This default approach is protects against
the simplest attempts at packet sniffing, but it is still vulnerable
to man-in-the-middle attacks. When greater security is required,
consider generating a PEM-encoded certificate and associated
private key yourself and using a trusted certificate authority (CA)
to sign the former. The documentation of \code{mirai}, including the
\code{tls} arguments of the \code{mirai::daemons()} and \code{mirai::server()}
functions, has more details.}

\item{seconds_interval}{Number of seconds between
polling intervals waiting for certain internal
synchronous operations to complete. If \code{space_poll} is \code{TRUE}, then
this is also the minimum number of seconds between calls to
\code{mirai::daemons()} for the purposes of checking worker status.}

\item{seconds_timeout}{Number of seconds until timing
out while waiting for certain synchronous operations to complete.}
}
\description{
Create an \code{R6} wrapper object to manage the \code{mirai} client.
}
\examples{
if (identical(Sys.getenv("CREW_EXAMPLES"), "true")) {
client <- crew_client()
client$start()
client$log()
client$terminate()
}
}
\seealso{
Other developer: 
\code{\link{crew_controller}()},
\code{\link{crew_launcher}()},
\code{\link{crew_schedule}()}
}
\concept{developer}
