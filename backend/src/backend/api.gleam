import backend/context
import gleam/result
import middle/endpoint
import middle/query
import middle/song
import middle/tag
import wisp

pub type Error

pub fn api(ctx: context.Context, endpoint: endpoint.Endpoint) -> wisp.Response {
  api_inner(ctx, endpoint)
  |> result.unwrap(wisp.internal_server_error())
}

fn api_inner(
  ctx: context.Context,
  endpoint: endpoint.Endpoint,
) -> Result(wisp.Response, Nil) {
  case endpoint {
    // Query Endpoints
    endpoint.Query(page:, query:) -> process_query(ctx, page, query)

    // Song Endpoints
    endpoint.SongDelete(id:) -> process_song_delete(ctx, id)
    endpoint.SongUpdate(song:) -> process_song_update(ctx, song)

    // Tag Endpoints
    endpoint.TagDelete(id:) -> process_tag_delete(ctx, id)
    endpoint.TagGet -> process_tag_get(ctx)
    endpoint.TagUpdate(tag:) -> process_tag_update(ctx, tag)
  }
}

fn process_tag_update(
  ctx: context.Context,
  tag: tag.Tag,
) -> Result(wisp.Response, Nil) {
  todo
}

fn process_tag_get(ctx: context.Context) -> Result(wisp.Response, Nil) {
  todo
}

fn process_tag_delete(
  ctx: context.Context,
  id: tag.Id,
) -> Result(wisp.Response, Nil) {
  todo
}

fn process_song_update(
  ctx: context.Context,
  song: song.Song,
) -> Result(wisp.Response, Nil) {
  todo
}

fn process_song_delete(
  ctx: context.Context,
  id: song.Id,
) -> Result(wisp.Response, Nil) {
  todo
}

fn process_query(
  ctx: context.Context,
  page: Int,
  query: query.Query,
) -> Result(wisp.Response, Nil) {
  todo
}
