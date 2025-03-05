# ANTHROPIC API for R users

Tools to use the [claude/anthropic](https://docs.anthropic.com/en/home) LLM model's API from R.

## Usage

### Functions

The following functions are available in [scripts/functions/anthropic.R](scripts/functions/anthropic.R):

- `create_anthropic_body(message, model = "claude-3-7-sonnet-20250219", max_tokens = 1024)`: Creates the request body for the Anthropic API.
- `send_anthropic_request(body, api_key = NULL)`: Sends a request to the Anthropic API using the specified model.

Here are some examples of how to use the functions:

### Create Request Body

```r
box::use(
    scripts/functions/anthropic[
        create_anthropic_body, 
        send_anthropic_request,
    ],
)

body <- create_anthropic_body("Provide a short answer: What's an API?", max_tokens = 50)
body
```

### Send Request to Anthropic API

```r
response <- send_anthropic_request(body)
print(response)

# > An API (Application Programming Interface) is a set of rules and protocols that allows different 
# software applications to communicate with each other. It defines the methods and data formats that 
# applications can use to request and exchange information.
```

### Example Script

You can find an example script in [scripts/drafts/test-api.R](scripts/drafts/test-api.R). This script demonstrates how to fetch exchange rate data from banks, process it, and send a request to the Anthropic API.

### Environment Variables

Ensure you have the `ANTHROPIC_API_KEY` environment variable set in your `.Renviron` file:

```r
ANTHROPIC_API_KEY="your_api_key_here"
```