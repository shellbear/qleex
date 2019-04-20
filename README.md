# Qleex

A minimal HTTP Middleware router for Crystal.

## Installation

Add this to your application's `shard.yml`:

```yaml
dependencies:
  qleex:
    github: ShellBear/qleex
```

## Usage

```crystal
require "http/server"
require "qleex"

router = Qleex::Router.new

# You can define one or more paths for get, post, put, delete, patch and options HTTP methods
router.get("/hello", -> (context : Qleex::Context, params : Qleex::Parameters) {
  context.response.content_type = "text/plain"
  context.response.print "Hello world!"
})

router.post("/post", -> (context : Qleex::Context, params : Qleex::Parameters) {
  context.response.content_type = "text/plain"
  context.response.print "This is POST request"
})

# You can define multiple methods for one or more paths.
router.route(["GET", "POST"], "/ping", -> (context : Qleex::Context, params : Qleex::Parameters) {
  context.response.content_type = "text/plain"
  context.response.print "pong"
})

# You can define multiple paths for one or more methods.
router.route("GET", ["/ex1", "/ex2", "/ex3"], -> (context : Qleex::Context, params : Qleex::Parameters) {
  context.response.content_type = "text/plain"
  context.response.print "You matched one of these URLs: [/ex1, /ex2, /ex3]"
})

# You can add parameters to the path by using the ":" character
router.route("GET", "/user/:id", -> (context : Qleex::Context, params : Qleex::Parameters) {
  context.response.content_type = "text/plain"
  context.response.print "User #{params["id"]}"
})

# You can use a wildcard to match everything
router.route("GET", "/*", -> (context : Qleex::Context, params : Qleex::Parameters) {
  context.response.content_type = "text/plain"
  context.response.print "Wow"
})

server = HTTP::Server.new(router)

address = server.bind_tcp 8080
puts "Listening on http://#{address}"
server.listen
```
