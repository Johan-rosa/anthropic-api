library(dplyr)
library(jsonlite)
library(stringr)
library(glue)

box::use(
  ../functions/anthropic[
    create_anthropic_body, 
    send_anthropic_request,
  ],
)

# Analysis inputs --------------------------------------------------

get_tc_from_banks <- function() {
  URL <- paste0(
    "https://raw.githubusercontent.com/",
    "Johan-rosa/webscraping-tc/refs/heads/", 
    "main/data/from_banks/_historico_from_banks.csv"
  )
  readr::read_csv(URL)
}

tc_banks <- get_tc_from_banks() |>
  filter(
    # Remover una de las tasas de scotia
    is.na(tipo) |
      str_detect(tipo, "Digitales")
  ) |>
  select(-tipo) |>
  arrange(date) |>
  group_by(bank) |>
  mutate(
    gap = sell - buy,
    lag_date = lag(date),
    lag_buy = lag(buy),
    lag_sell = lag(sell),
    lag_gap = lag(gap),
    d_sell = sell - lag_sell,
    d_buy = buy - lag_buy,
  ) |>
  ungroup()

current_date <- max(tc_banks$date)
previous_date <- max(tc_banks$lag_date, na.rm = TRUE)

current_data <- tc_banks |>
  filter(date == max(date))

current_summary <- tc_banks |>
  filter(date == max(date)) |>
  summarise(
    across(-c(bank, date, lag_date), \(x) mean(x, na.rm = TRUE)),
    n_banks = n()
  )


# Prepare and perform request -----------------------------------------------

message <- glue(
  "
  I need a short summary in spanish about the recent changes in the exchange rates of the Banks in the Dominican Republic,
  Here is the data by banks a symmary of the average results.
  
  data by banks: {toJSON(current_data)}
  
  data summary: {toJSON(current_summary)}
  
  context: the data is from {current_date} and lag_* values are from {previous_date}
  
  Instructions for the output:
  MD formatted 
  "
)

body <- create_anthropic_body(message = message)
content <- send_anthropic_request(body)

cat(content$content[[1]]$text)
