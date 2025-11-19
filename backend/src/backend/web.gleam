import backend/api
import backend/context
import backend/log
import gleam/int
import gleam/result
import middle/endpoint
import wisp

pub fn handle_request(ctx: context.Context, req: wisp.Request) -> wisp.Response {
  use ctx, req <- middleware(ctx, req)

  let response =
    req
    |> endpoint.parse()
    |> result.map(api.api(ctx, _))

  case response {
    Ok(response) -> response
    Error(endpoint.BadRequest) -> wisp.bad_request("Invalid Request")
    Error(endpoint.NotFound) -> wisp.not_found()
  }
}

pub fn middleware(
  ctx: context.Context,
  req: wisp.Request,
  callback: fn(context.Context, wisp.Request) -> wisp.Response,
) -> wisp.Response {
  use <- wisp.rescue_crashes()
  use <- log_request(ctx, req)

  callback(ctx, req)
}

fn log_request(
  ctx: context.Context,
  req: wisp.Request,
  callback: fn() -> wisp.Response,
) -> wisp.Response {
  log.info(ctx, "got request: " <> req.path)
  let response = callback()

  let message = "response status: " <> int.to_string(response.status)

  case response.status != 200 {
    False -> log.error(ctx, message)
    True -> log.info(ctx, message)
  }

  response
}
