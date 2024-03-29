% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/read.R
\name{get_partners}
\alias{get_partners}
\title{Retrieve a List of All Partners}
\usage{
get_partners(..., test_db = FALSE)
}
\arguments{
\item{...}{List of attribute-value pairs with which to filter the list of
returned partners.}

\item{test_db}{Retrieve this data from the test database? Defaults to
\code{FALSE}.}
}
\value{
A tibble containing 9 columns, where each row is a partner.
}
\description{
Returns a list of partners from the database, plus the names and IDs of any
facilities they're associated with.
}
\examples{
charitable_trusts <- get_partners(type = "Charitable Trust", test_db = TRUE)
charitable_trusts

}
