# how to format dates for entering into the test database
dt_fmt <- "%Y-%m-%d"

# an asset is a physical structure within which the public can take shelter; typically these are buildings
test_assets <- tibble::tribble(
  ~id,      ~name,                        ~local_board,    ~asset_type,            ~physical_address,                ~latitude, ~longitude, ~land_ownership, ~image,
  "A26",    "Buckland Community Centre",  "Franklin",     "Standalone Building",  "Cnr Logan and Buckville Road",     NA,        NA,         NA,              NA,
  "A58",    "Franklin The Centre",        "Franklin",     "Standalone Building",  "12 Massey Avenue",                 NA,        NA,         NA,              NA
)

# a space is an area that fulfills a public need, houses within an asset; typically these are rooms
test_spaces <- tibble::tribble(
  ~id,    ~name,                        ~asset_id,  ~bookable,  ~booking_method,  ~image,
  "S1",    "Main Hall",                  "A26",      "Y",         NA,               NA,
  "S374",  "Community Gallery",          "A58",       NA,         NA,               NA,
  "S375",  "New Zealand Steel Gallery",  "A58",       NA,         NA,               NA,
  "S376",  "Workshop",                   "A58",       NA,         NA,               NA
)

# an entity is a construct, assigned by Auckland Council, that groups together assets, spaces, or services
test_entities <- tibble::tribble(
  ~id,    ~name,
  "E01",   "Franklin Arts Centre"
)

# entity_bridge_table connects assets, spaces, and/or services to an entity
test_entity_bridge_table <- tibble::tribble(
  ~id,    ~facility_type,    ~facility_id,   ~entity_id,    ~valid_from,                        ~valid_to,            ~notes,
  "EB01",  "asset",           "A58",          "E01",         as.Date("2022-07-01", dt_fmt),      NA,                   "",
  "EB32",  "space",           "S374",         "E01",         as.Date("2022-07-01", dt_fmt),      NA,                   "",
  "EB33",  "space",           "S375",         "E01",         as.Date("2022-07-01", dt_fmt),      NA,                   "",
  "EB34",  "space",           "S376",         "E01",         as.Date("2022-07-01", dt_fmt),      NA,                   ""
)

# attributes describe facilities
test_facilities_attributes <- tibble::tribble(
  ~id,    ~facility_type,    ~facility_id,    ~designation,    ~delivery_model,            ~facility_ownership,    ~staffed,    ~closed,    ~leased,
  "FA174", "Asset",           "A26",            "Rural Hall",   "Community-led facility",   "Privately-owned",      FALSE,        FALSE,      FALSE,
  "FA251", "Asset",           "A58",            "Hybrid",       "Council-led facility",     NA,                     NA,           NA,         NA,
  "FA601", "Space",           "S374",           "Room",         "Council-led facility",     NA,                     NA,           FALSE,      NA,
  "FA602", "Space",           "S375",           "Room",         "Council-led facility",     NA,                     NA,           FALSE,      NA,
  "FA603", "Space",           "S376",           "Room",         "Council-led facility",     NA,                     NA,           FALSE,      NA
)

# primary and alternate names for facilities
test_names <- tibble::tribble(
  ~id,    ~value,                        ~role,        ~facilities_attributes_id,
  "1",     "Buckland Hall",              "alternate",   "FA174",
  "91",    "Buckland Community Centre",  "primary",     "FA174",
  "71",    "Franklin: The Centre",       "alternate",   "FA251",
  "372",   "Franklin The Centre",        "primary",     "FA251",
  "679",   "Community Gallery",          "primary",     "FA601",
  "680",   "New Zealand Steel Gallery",  "primary",     "FA602",
  "681",   "Workshop",                   "primary",     "FA603"
)

usethis::use_data(
  test_assets,
  test_spaces,
  test_entities,
  test_entity_bridge_table,
  test_facilities_attributes,
  test_names,
  overwrite = TRUE
  )
