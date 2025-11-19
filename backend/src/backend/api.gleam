import backend/context
import backend/db
import backend/log
import gleam/json
import gleam/result
import middle/song
import wisp

pub fn api(ctx: context.Context, req: wisp.Request) -> wisp.Response {
  case wisp.path_segments(req) {
    // song endpoints
    ["api", "song", "get", "all"] -> process_song_get_all(ctx) |> nil_wrapper()
    _ -> wisp.not_found()
  }
}

fn nil_wrapper(result: Result(wisp.Response, Nil)) -> wisp.Response {
  result
  |> result.unwrap(wisp.internal_server_error())
}

fn process_song_get_all(ctx: context.Context) -> Result(wisp.Response, Nil) {
  log.info(ctx, "fetching songs")

  let songs = db.song_get_all(ctx)
  use songs <- result.try(songs)

  [#("songs", songs |> json.array(song.to_json))]
  |> json.object()
  |> json.to_string()
  |> wisp.json_response(200)
  |> Ok
}
