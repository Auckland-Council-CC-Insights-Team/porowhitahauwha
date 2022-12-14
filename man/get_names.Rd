% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/read.R
\name{get_names}
\alias{get_names}
\title{Find Facility Names and Aliases in the Database}
\usage{
get_names(..., test_db = FALSE)
}
\arguments{
\item{...}{Optional arguments passed to the \code{get_names} to filter the
names returned.}

\item{test_db}{Retrieve this data from the test database (\code{TRUE}) or
not (\code{FALSE}). Defaults to \code{FALSE}.}
}
\value{
A tibble.
}
\description{
Call this function without passing any arguments to return the entire content
of the names table, otherwise filter the table by any of its variables for a
more specific response.
}
\examples{
# Search for a facility and return any aliases
get_names(value == "Buckland Community Centre", test_db = TRUE)
}
