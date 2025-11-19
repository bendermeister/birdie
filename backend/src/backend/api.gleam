import backend/context
import gleam/result
import pog
import wisp

pub fn api(ctx: context.Context, req: wisp.Request) -> wisp.Response {
  case wisp.path_segments(req) {
    ["api", "song", "get", "all"] -> process_song_get_all(ctx) |> nil_wrapper()
    _ -> wisp.not_found()
  }
}

fn nil_wrapper(result: Result(wisp.Response, Nil)) -> wisp.Response {
  result
  |> result.unwrap(wisp.internal_server_error())
}

fn process_song_get_all(ctx: context.Context) -> Result(wisp.Response, Nil) {
  todo
}
