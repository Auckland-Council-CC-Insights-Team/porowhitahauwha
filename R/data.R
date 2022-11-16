#' Porowhita Hauwhā test data: assets
#'
#' @description
#' A subset of the data stored in the Porowhitā Hauwha table called \code{assets}.
#' An asset is a physical structure that provides shelter for the public, typically
#' a building.
#'
#' This data has been made available for use in package documentation examples,
#' and for the user to explore the kind of information stored in the live
#' Porowhita Hauwhā database.
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

#' Porowhita Hauwhā test data: spaces
#'
#' @description
#' A subset of the data stored in the Porowhitā Hauwha table called \code{spaces}.
#' A space is a an area in which services are delivered to the public; a space
#' is typically a room.
#'
#' This data has been made available for use in package documentation examples,
#' and for the user to explore the kind of information stored in the live
#' Porowhita Hauwhā database.
#'
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

#' Porowhita Hauwhā test data: entities
#'
#' @description
#' A subset of the data stored in the Porowhitā Hauwha table called \code{entities}.
#' An entity is a construct, assigned by Auckland Council, that groups together
#' assets, spaces, or services.
#'
#' This data has been made available for use in package documentation examples,
#' and for the user to explore the kind of information stored in the live
#' Porowhita Hauwhā database.
#'
#' @format ## 'test_entities'
#' A data frame with 1 row and 2 columns:
#'  \describe{
#'    \item{id}{Unique identifier. This is the primary key for the table.}
#'    \item{name}{The primary name of the entity.}
#'  }
"test_entities"

#' Porowhita Hauwhā test data: facilities_attributes
#'
#' @description
#' A subset of the data stored in the Porowhitā Hauwha table called \code{facilities_attributes}.
#'
#' The need for a separate table to store information (or attributes) about
#' facilities is because assets, spaces, and entities have common fields; managing
#' those fields here simplifies the process of managing the data.
#'
#' This data has been made available for use in package documentation examples,
#' and for the user to explore the kind of information stored in the live
#' Porowhita Hauwhā database.
#'
#' @format ## 'test_facilities_attributes'
#' A data frame with 5 rows and 9 columns:
#'  \describe{
#'    \item{id}{Unique identifier. This is the primary key for the table.}
#'    \item{property_code}{}
#'    \item{provider_legal_status_number}{}
#'    \item{entry_access_type}{}
#'    \item{facility_type}{Describes whether this facility is an asset, a space, or an entity.}
#'    \item{facility_id}{A foreign key for joining to the relevant facilities table, as defined by \code{facility_type}.}
#'    \item{designation}{Describes the function of this facility, for example "Rural Hall", "Community Library", "Room" etc.}
#'    \item{delivery_model}{Categorises the facility as either community-led or Council-led. A community-led facility is operated by community partners.}
#'    \item{facility_ownership}{Describes whether the facility is owned by Council, by Kainga Ora, or is privately owned.}
#'    \item{staffed}{Is the facility staffed during opening hours (\code{TRUE}) or not (\code{FALSE})?}
#'    \item{closed}{Is the facility currently closed to the public (\code{TRUE}) or not (\code{FALSE})?}
#'    \item{leased}{Is there a community lease agreement in place for this facility (\code{TRUE}) or not (\code{FALSE})?}
#'  }
"test_facilities_attributes"

#' Porowhita Hauwhā test data: names
#'
#' @description
#' A subset of the data stored in the Porowhitā Hauwha table called \code{names}.
#'
#' Each facility, whether an asset, a space, or an entity, should have at least
#' one record in this table: a name of role "primary". Some facilities also have
#' at least one name of role "alternate" where we're aware of any alternate names.
#' The primary name is also the name used in the relevant table, whether an asset,
#' a space, or an entity.
#'
#' This data has been made available for use in package documentation examples,
#' and for the user to explore the kind of information stored in the live
#' Porowhita Hauwhā database.
#'
#' @format ## 'test_names'
#' A data frame with 7 rows and 4 columns:
#'  \describe{
#'    \item{id}{Unique identifier. This is the primary key for the table.}
#'    \item{value}{The name of the facility, categorised by the \code{role} field.}
#'    \item{role}{Categorises the name stored in \code{value} as either the primary or alternate name used for this facility. A facility can have multiple alternate names.}
#'    \item{facilities_attributes_id}{A foreign key for joining to the \code{facilities_attributes} table, where more information about this facility is found.}
#'  }
"test_names"

#' Porowhita Hauwhā test data: entity_bridge_table
#'
#' @description
#' A subset of the data stored in the Porowhitā Hauwha table called \code{entity_bridge_table}.
#'
#' An entity is composed of at least two records in either the assets, spaces, or services
#' tables. This table joins the entity to the assets, spaces, or service from which
#' it is formed.
#'
#' This data has been made available for use in package documentation examples,
#' and for the user to explore the kind of information stored in the live
#' Porowhita Hauwhā database.
#'
#' @format ## 'test_entity_bridge_table'
#' A data frame with 4 rows and 7 columns:
#'  \describe{
#'    \item{id}{Unique identifier. This is the primary key for the table.}
#'    \item{facility_type}{Describes whether this facility is an asset, a space, or an entity.}
#'    \item{facility_id}{A foreign key for joining to the relevant facilities table, as defined by \code{facility_type}.}
#'    \item{entity_id}{A foreign key for joining to the \code{entities} table.}
#'    \item{valid_from}{A date defining a point in time from which this relationship was established.}
#'    \item{valid_to}{A date defining a point in time from which this relationship was disestablished.}
#'    \item{notes}{An explanation for why this relationship was disestablished.}
#'  }
"test_entity_bridge_table"

#' Porowhita Hauwhā test data: partners
#'
#' @description
#' A subset of the data stored in the Porowhitā Hauwha table called \code{partners}.
#'
#' Partners are supported by Auckland Council to deliver services in the community.
#' This support is typically codified in an agreement, which is described in the \code{agreements}
#' table.
#'
#' Often some sort of funding is provided to the partner by Auckland Council as
#' part of this agreement, which is described in the \code{funding} table.
#'
#' Partners usually operate out of a facility, which they may or may not own
#' themselves. The relationship between the partner and any such facility or
#' facilities is described in the \code{partners_bridge_table}.
#'
#' The relationship between Auckland Council and the partner is managed by a Place
#' and Partner Specialist. The Place and Partner Specialist is described in the \code{staff}
#' table, and they are attached to a facility operated by a partner with whom they hold
#' the relationship via the \code{staff_bridge_table}.
#'
#' Finally, any individuals associated with this partner are described in the \code{contacts}
#' table; this include the Chairperson, the site manager (if applicable), and the person
#' respnsible for reporting Key Performance Indicators to Auckland Council as defined
#' in the agreement. It is possible, although unlikely, that the Chairperson, the
#' site manager, and the reporting contact are all the same individual.
#'
#' This data has been made available for use in package documentation examples,
#' and for the user to explore the kind of information stored in the live
#' Porowhita Hauwhā database.
#'
#' @format ## 'test_partners'
#' A data frame with 1 rows and 6 columns:
#'  \describe{
#'    \item{id}{Unique identifier. This is the primary key for the table.}
#'    \item{name}{The name of the partner.}
#'    \item{type}{Is this partner a Charitable Trust, an Incorporated Society, or Other?}
#'    \item{facility_owner}{Does this partner own the facility in which they operate (\code{TRUE}) or not (\code{FALSE})?}
#'    \item{service_provider}{Does this partner provide services (\code{TRUE}) or not (\code{FALSE})?}
#'    \item{legal_status_number}{The Legal Status Number for this partner, if available.}
#'  }
"test_partners"

#' Porowhita Hauwhā test data: facilities_attributes_bridge_table
#'
#' @description
#' A subset of the data stored in the Porowhitā Hauwha table called \code{facilities_attributes_bridge_table}.
#'
#' When information about a facility is updated, an entry is created in this table to note what changed,
#' when the change occurred, and why it changed.
#'
#' @format ## 'test_facilities_attributes_bridge_table'
#' A data frame with 2 rows and 9 columns:
#'  \describe{
#'    \item{id}{Unique identifier. This is the primary key for the table.}
#'    \item{facility_attribute_id}{Foreign key to join on the facilities_attributes table.}
#'    \item{facility_type}{Is the facility an asset, a space, or an entity?}
#'    \item{facility_id}{Foreign key for joining on the assets, spaces, or entities table.}
#'    \item{attribute}{Which field has changed its value?}
#'    \item{value}{What is the changed value?}
#'    \item{valid_from}{On which date did this change take effect?}
#'    \item{valid_to}{Until when is this change valid?}
#'    \item{notes}{What is the reason for this change?}
#'  }
"test_facilities_attributes_bridge_table"
