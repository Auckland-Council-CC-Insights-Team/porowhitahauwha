library(dplyr)

get_libraries_hubs <- get_libraries() |>
  dplyr::mutate(community_hub_name = dplyr::if_else(
    local_board == "Franklin" & facility_name %in% c("Pukekohe Library", "Waiuku Library"),
    "Franklin Community Hub",
    dplyr::if_else(
      local_board == "Whau" & facility_name == "New Lynn War Memorial Library",
      "New Lynn Hub",
      dplyr::if_else(
        local_board == "Henderson-Massey" & facility_name == "Te Manawa Library",
        "Te Manawa Hub",
        dplyr::if_else(local_board == "Maungakiekie-Tamaki" & facility_name == "Onehunga Library", "Onehunga and Oranga Hub", NA)
      )
    )
  )
  )

get_community_spaces_df <- get_community_spaces()

get_entities_df <- get_entities()

get_assets_df <- get_assets()

get_spaces_hubs <- get_spaces() |>
  dplyr::select(local_board,
                facility_name = name,
                physical_address,
                designation) |>
  dplyr::filter(!designation == "Community Library") |>
  dplyr::mutate(
    community_hub_name = dplyr::if_else(
      local_board == "Franklin" & facility_name == "Weta Workshop",
      "Franklin Community Hub",
      dplyr::if_else(
        local_board == "Whau" & facility_name == "Community Centre Service desk/office",
        "New Lynn Hub", NA)
      )
    ) |>
  dplyr::mutate(source = "spaces")

get_entities_hubs <- get_entities() |>
  dplyr::select(local_board,
                facility_name = name,
                physical_address,
                designation) |>
  dplyr::mutate(community_hub_name = dplyr::if_else(local_board == "Franklin" & facility_name == "Franklin Arts Centre", "Franklin Community Hub",
                                                    dplyr::if_else(local_board == "Henderson-Massey" & facility_name == "Te Manawa Hub",  "Te Manawa Hub", NA)),
                source = "entities"
                )

result <- dplyr::bind_rows(get_libraries_hubs, get_spaces_hubs, get_entities_hubs) |>
  dplyr::filter(designation == "Community Library" | stringr::str_detect(community_hub_name, stringr::regex("hub", ignore_case = TRUE))) |>
  dplyr::filter(!(facility_name == "Central City Library" & is.na(source))) |>
  dplyr::select(!source)
