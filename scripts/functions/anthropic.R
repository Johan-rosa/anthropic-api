#' Create request body for Anthropic API
#'
#' This function generates the request body for the Anthropic API.
#'
#' @param message A character string with the user message.
#' @param model A character string specifying the AI model (default: `"claude-3-7-sonnet-20250219"`).
#' @param max_tokens An integer specifying the maximum number of tokens in the response (default: `1024`).
#'
#' @return A named list representing the request body.
#' @export
#'
#' @examples
#' create_anthropic_body("Hello, world!")

create_anthropic_body <- function(
    message, 
    model = "claude-3-7-sonnet-20250219", 
    max_tokens = 1000
) {
  list(
    model = model,
    max_tokens = max_tokens,
    messages = list(list(role = "user", content = message))
  )
}

#' Send a message to Anthropic API
#'
#' This function sends a request to the Anthropic API using the specified model.
#'
#' @param body A named list containing the request body, typically created by `create_anthropic_body()`.
#' @param api_key A character string containing the API key. If `NULL`, it will use the `ANTHROPIC_API_KEY` environment variable.
#'
#' @return A list containing the API response.
#' @export
#'
#' @examples
#' \dontrun{
#' body <- create_anthropic_body("Hello, world!")
#' send_anthropic_request(body)
#' }

send_anthropic_request <- function(body, api_key = NULL) {
  
  url <- "https://api.anthropic.com/v1/messages"
  api_key <- api_key %||% Sys.getenv("ANTHROPIC_API_KEY")
  
  if (api_key == "") {
    stop("API key is missing. Set it in the function argument or as an environment variable.")
  }
  
  response <- httr2::request(url) |>
    httr2::req_headers(
      "x-api-key" = api_key,
      "anthropic-version" = "2023-06-01",
      "content-type" = "application/json"
    ) |>
    httr2::req_body_json(body) |>
    httr2::req_perform()
  
  httr2::resp_body_json(response)
}
