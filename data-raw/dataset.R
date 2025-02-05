atdb_pretty_cols <- data.frame(
  to = c(
    "atdb_id", "supplier", "recipient", "designation", "description",
    "armament_category", "order_date", "order_date_is_estimate",
    "numbers_delivered", "numbers_delivered_is_estimate",
    "delivery_year", "delivery_year_is_estimate", "status",
    "sipri_estimate", "tiv_deal_unit", "tiv_delivery_values",
    "local_production"
  ),
  from = c(
    "SIPRI AT Database ID", "Supplier", "Recipient", "Designation", "Description",
    "Armament category", "Order date", "Order date is estimate",
    "Numbers delivered", "Numbers delivered is estimate",
    "Delivery year", "Delivery year is estimate", "Status",
    "SIPRI estimate", "TIV deal unit", "TIV delivery values",
    "Local production"
  )
)

usethis::use_data(atdb_pretty_cols, overwrite = TRUE)
