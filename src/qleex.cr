module Qleex
  # The available HTTP methods
  HTTP_METHODS = ["GET", "POST", "PUT", "DELETE", "PATCH", "OPTIONS"]

  alias Context = HTTP::Server::Context
  alias Parameters = Hash(String, String)

  # The function prototype used by the router for each endpoint
  alias RouterMethod = (Context, Parameters) -> Nil
end

require "./router"
require "./errors"
