library(dplyr)

get_libraries_df <- get_libraries()

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
      local_board == "Franklin",
      "Franklin Community Hub",
      dplyr::if_else(
        local_board == "Whau",
        "New Lynn Hub",
        dplyr::if_else(
          local_board == "Henderson-Massey",
          "Te Manawa Hub",
          dplyr::if_else(local_board = "Maungakiekie-Tamaki", "Onehunga and Oranga Hub", NA)
        )
      )
    )
  ) |>
  dplyr::mutate(source = "spaces")

get_entities_hubs <- get_entities() |>
  dplyr::select(local_board,
                facility_name = name,
                physical_address,
                designation) |>
  dplyr::mutate(community_hub_name = dplyr::if_else(local_board == "Franklin", "Franklin Community Hub", NA),
                source = "entities"
                )

result <- dplyr::bind_rows(get_libraries(), get_spaces_hubs, get_entities_hubs)
