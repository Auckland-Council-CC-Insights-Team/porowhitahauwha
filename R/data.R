#' Porowhita Hauwhā test data
#'
#' @description
#' A subset of the data stored in Porowhitā Hauwha. This has been made available
#' for use in package documentation examples, and for the user to explore the
#' kind of information stored in the live Porowhitā Hauwhā database.
#'
#' @format ## 'test_assets'
#' A data frame with 2 rows and 9 columns:
#'  \describe{
#'    \item{id}{Unique identifier. This is the primary key for the table.}
#'    \item{name}{The primary name of the asset.}
#'    \item{local_board}{The Local Board in which this asset is located.}
#'    \item{asset_type}{Is this asset a standalone building, a vehicle, or some other type of structure?}
#'    \item{physical_address}{The physical address of the asset, including street name and number (where available).}
#'    \item{latitude}{What is the latitude of this asset?}
#'    \item{longitude}{What is the longitude of this asset?}
#'    \item{image}{A url to an image of this asset, if available.}
#'  }
"test_assets"

#' @format ## 'test_spaces'
#' A data frame with 4 rows and 6 columns:
#'  \describe{
#'    \item{id}{Unique identifier. This is the primary key for the table.}
#'    \item{name}{The primary name of the space.}
#'    \item{asset_id}{A foreign key for joining spaces with assets.}
#'    \item{bookable}{Is this a bookable space? TRUE if it is, FALSE if not.}
#'    \item{booking_method}{If this is a bookable space, how is it booked? For example, "Sphere".}
#'    \item{image}{A url to an image of this asset, if available.}
#'  }
"test_spaces"
