import backend/context
import backend/db
import backend/log
import gleam/dynamic/decode
import gleam/int
import gleam/json
import gleam/result
import middle/album
import middle/album_artist
import middle/album_song
import middle/album_tag
import middle/artist
import middle/song
import middle/song_artist
import middle/song_tag
import middle/tag
import wisp

pub fn api(ctx: context.Context, req: wisp.Request) -> wisp.Response {
  case wisp.path_segments(req) {
    // song endpoints
    ["api", "song", "create", "default"] ->
      process_song_create_default(ctx) |> wrapper_nil()
    ["api", "song", "get", "all"] -> process_song_get_all(ctx) |> wrapper_nil()
    ["api", "song", "delete", id] ->
      process_song_delete(ctx, id) |> wrapper_nil()
    ["api", "song", "update"] -> process_song_update(ctx, req) |> wrapper_nil()

    // tag endpoints
    ["api", "tag", "create", "default"] ->
      process_tag_create_default(ctx) |> wrapper_nil()
    ["api", "tag", "get", "all"] -> process_tag_get_all(ctx) |> wrapper_nil()
    ["api", "tag", "delete", id] -> process_tag_delete(ctx, id) |> wrapper_nil()
    ["api", "tag", "update"] -> process_tag_update(ctx, req) |> wrapper_nil()

    // album endpoints
    ["api", "album", "create", "default"] ->
      process_album_create_default(ctx) |> wrapper_nil()
    ["api", "album", "get", "all"] ->
      process_album_get_all(ctx) |> wrapper_nil()
    ["api", "album", "delete", id] ->
      process_album_delete(ctx, id) |> wrapper_nil()
    ["api", "album", "update"] ->
      process_album_update(ctx, req) |> wrapper_nil()

    // artist endpoints
    ["api", "artist", "create", "default"] ->
      process_artist_create_default(ctx) |> wrapper_nil()
    ["api", "artist", "get", "all"] ->
      process_artist_get_all(ctx) |> wrapper_nil()
    ["api", "artist", "delete", id] ->
      process_artist_delete(ctx, id) |> wrapper_nil()
    ["api", "artist", "update"] ->
      process_artist_update(ctx, req) |> wrapper_nil()

    // song_tag endpoints
    ["api", "song_tag", "get", "all"] ->
      process_song_tag_get_all(ctx) |> wrapper_nil()
    ["api", "song_tag", "delete"] ->
      process_song_tag_delete(ctx, req) |> wrapper_nil()
    ["api", "song_tag", "upsert"] ->
      process_song_tag_upsert(ctx, req) |> wrapper_nil()

    // album_song endpoints
    ["api", "album_song", "get", "all"] ->
      process_album_song_get_all(ctx) |> wrapper_nil()
    ["api", "album_song", "delete"] ->
      process_album_song_delete(ctx, req) |> wrapper_nil()
    ["api", "album_song", "upsert"] ->
      process_album_song_upsert(ctx, req) |> wrapper_nil()

    // album_tag endpoints
    ["api", "album_tag", "get", "all"] ->
      process_album_tag_get_all(ctx) |> wrapper_nil()
    ["api", "album_tag", "delete"] ->
      process_album_tag_delete(ctx, req) |> wrapper_nil()
    ["api", "album_tag", "upsert"] ->
      process_album_tag_upsert(ctx, req) |> wrapper_nil()

    // song_artist endpoints
    ["api", "song_artist", "get", "all"] ->
      process_song_artist_get_all(ctx) |> wrapper_nil()
    ["api", "song_artist", "delete"] ->
      process_song_artist_delete(ctx, req) |> wrapper_nil()
    ["api", "song_artist", "upsert"] ->
      process_song_artist_upsert(ctx, req) |> wrapper_nil()

    // album_artist endpoints
    ["api", "album_artist", "get", "all"] ->
      process_album_artist_get_all(ctx) |> wrapper_nil()
    ["api", "album_artist", "delete"] ->
      process_album_artist_delete(ctx, req) |> wrapper_nil()
    ["api", "album_artist", "upsert"] ->
      process_album_artist_upsert(ctx, req) |> wrapper_nil()
    _ -> wisp.not_found()
  }
}

fn req_body_parse(
  ctx: context.Context,
  req: wisp.Request,
  decoder: decode.Decoder(a),
) -> Result(a, Nil) {
  req
  |> wisp.read_body_bits()
  |> log.on_error(ctx, "could not read request body")
  |> result.try(fn(body) {
    body
    |> json.parse_bits(decoder)
    |> log.on_error(ctx, "could not parse request body")
    |> result.replace_error(Nil)
  })
}

fn id_parse(
  ctx: context.Context,
  id: String,
  wrapper: fn(Int) -> a,
) -> Result(a, Nil) {
  id
  |> int.parse()
  |> result.map(wrapper)
  |> log.on_error(ctx, "could not parse id")
}

fn wrapper_nil(result: Result(wisp.Response, Nil)) -> wisp.Response {
  result
  |> result.unwrap(wisp.internal_server_error())
}

fn json_to_response(json: json.Json) -> wisp.Response {
  json
  |> json.to_string
  |> wisp.json_response(200)
}

fn process_song_create_default(
  ctx: context.Context,
) -> Result(wisp.Response, Nil) {
  song.Song(id: song.Id(-1), name: "new song", file_name: "")
  |> db.song_insert(ctx, _)
  |> log.on_error(ctx, "could not insert created default song")
  |> result.map(song.to_json)
  |> result.map(json_to_response)
}

fn process_song_get_all(ctx: context.Context) -> Result(wisp.Response, Nil) {
  db.song_get_all(ctx)
  |> log.on_error(ctx, "could not get all songs")
  |> result.map(json.array(_, song.to_json))
  |> result.map(json_to_response)
}

fn process_song_delete(
  ctx: context.Context,
  id: String,
) -> Result(wisp.Response, Nil) {
  id_parse(ctx, id, song.Id)
  |> result.try(db.song_delete(ctx, _))
  |> log.on_error(ctx, "could not delete song")
  |> result.replace(wisp.ok())
}

fn process_song_update(ctx: context.Context, req: wisp.Request) {
  req_body_parse(ctx, req, song.json_decoder())
  |> result.try(db.song_update(ctx, _))
  |> log.on_error(ctx, "could not upsert song")
  |> result.replace(wisp.ok())
}

fn process_tag_create_default(ctx: context.Context) {
  tag.Tag(id: tag.Id(-1), name: "new tag")
  |> db.tag_insert(ctx, _)
  |> log.on_error(ctx, "could not insert created default tag")
  |> result.map(tag.to_json)
  |> result.map(json_to_response)
}

fn process_tag_get_all(ctx: context.Context) {
  db.tag_get_all(ctx)
  |> log.on_error(ctx, "could not get all tags")
  |> result.map(json.array(_, tag.to_json))
  |> result.map(json.to_string)
  |> result.map(wisp.json_response(_, 200))
}

fn process_tag_delete(ctx: context.Context, id: String) {
  id_parse(ctx, id, tag.Id)
  |> result.try(db.tag_delete(ctx, _))
  |> log.on_error(ctx, "could not delete tag")
  |> result.replace(wisp.ok())
}

fn process_tag_update(ctx: context.Context, req: wisp.Request) {
  req_body_parse(ctx, req, tag.json_decoder())
  |> result.try(db.tag_update(ctx, _))
  |> log.on_error(ctx, "could not upsert tag")
  |> result.replace(wisp.ok())
}

fn process_album_create_default(ctx: context.Context) {
  album.Album(id: album.Id(-1), name: "new album")
  |> db.album_insert(ctx, _)
  |> log.on_error(ctx, "could not insert created default album")
  |> result.map(album.to_json)
  |> result.map(json_to_response)
}

fn process_album_get_all(ctx: context.Context) {
  db.album_get_all(ctx)
  |> log.on_error(ctx, "could not get all album")
  |> result.map(json.array(_, album.to_json))
  |> result.map(json_to_response)
}

fn process_album_delete(ctx: context.Context, id: String) {
  id_parse(ctx, id, album.Id)
  |> result.try(db.album_delete(ctx, _))
  |> log.on_error(ctx, "could not delete album")
  |> result.replace(wisp.ok())
}

fn process_album_update(ctx: context.Context, req: wisp.Request) {
  req_body_parse(ctx, req, album.json_decoder())
  |> result.try(db.album_update(ctx, _))
  |> log.on_error(ctx, "could not upsert album")
  |> result.replace(wisp.ok())
}

fn process_artist_create_default(ctx: context.Context) {
  artist.Artist(id: artist.Id(-1), name: "new artist")
  |> db.artist_insert(ctx, _)
  |> log.on_error(ctx, "could not create new artist")
  |> result.map(artist.to_json)
  |> result.map(json_to_response)
}

fn process_artist_get_all(ctx: context.Context) -> Result(wisp.Response, Nil) {
  db.artist_get_all(ctx)
  |> log.on_error(ctx, "could not get all artist")
  |> result.map(json.array(_, artist.to_json))
  |> result.map(json_to_response)
}

fn process_artist_delete(
  ctx: context.Context,
  id: String,
) -> Result(wisp.Response, Nil) {
  id_parse(ctx, id, artist.Id)
  |> result.try(db.artist_delete(ctx, _))
  |> log.on_error(ctx, "could not delete artist")
  |> result.replace(wisp.ok())
}

fn process_artist_update(
  ctx: context.Context,
  req: wisp.Request,
) -> Result(wisp.Response, Nil) {
  req_body_parse(ctx, req, artist.json_decoder())
  |> result.try(db.artist_update(ctx, _))
  |> log.on_error(ctx, "could not upsert artist")
  |> result.replace(wisp.ok())
}

fn process_song_tag_get_all(ctx: context.Context) -> Result(wisp.Response, Nil) {
  db.song_tag_get_all(ctx)
  |> log.on_error(ctx, "could not get all song_tag")
  |> result.map(json.array(_, song_tag.to_json))
  |> result.map(json_to_response)
}

fn process_song_tag_delete(
  ctx: context.Context,
  req: wisp.Request,
) -> Result(wisp.Response, Nil) {
  req_body_parse(ctx, req, song_tag.json_decoder())
  |> result.try(db.song_tag_delete(ctx, _))
  |> log.on_error(ctx, "could not delete song_tag")
  |> result.replace(wisp.ok())
}

fn process_song_tag_upsert(
  ctx: context.Context,
  req: wisp.Request,
) -> Result(wisp.Response, Nil) {
  req_body_parse(ctx, req, song_tag.json_decoder())
  |> result.try(db.song_tag_upsert(ctx, _))
  |> log.on_error(ctx, "could not upsert song_tag")
  |> result.replace(wisp.ok())
}

fn process_album_song_get_all(
  ctx: context.Context,
) -> Result(wisp.Response, Nil) {
  db.album_song_get_all(ctx)
  |> log.on_error(ctx, "could not get all album_song")
  |> result.map(json.array(_, album_song.to_json))
  |> result.map(json_to_response)
}

fn process_album_song_delete(
  ctx: context.Context,
  req: wisp.Request,
) -> Result(wisp.Response, Nil) {
  req_body_parse(ctx, req, album_song.json_decoder())
  |> result.try(db.album_song_delete(ctx, _))
  |> log.on_error(ctx, "could not delete album_song")
  |> result.replace(wisp.ok())
}

fn process_album_song_upsert(
  ctx: context.Context,
  req: wisp.Request,
) -> Result(wisp.Response, Nil) {
  req_body_parse(ctx, req, album_song.json_decoder())
  |> result.try(db.album_song_upsert(ctx, _))
  |> log.on_error(ctx, "could not upsert album_song")
  |> result.replace(wisp.ok())
}

fn process_album_tag_get_all(ctx: context.Context) -> Result(wisp.Response, Nil) {
  db.album_tag_get_all(ctx)
  |> log.on_error(ctx, "could not get all album_tag")
  |> result.map(json.array(_, album_tag.to_json))
  |> result.map(json_to_response)
}

fn process_album_tag_delete(
  ctx: context.Context,
  req: wisp.Request,
) -> Result(wisp.Response, Nil) {
  req_body_parse(ctx, req, album_tag.json_decoder())
  |> result.try(db.album_tag_delete(ctx, _))
  |> log.on_error(ctx, "could not delete album_tag")
  |> result.replace(wisp.ok())
}

fn process_album_tag_upsert(
  ctx: context.Context,
  req: wisp.Request,
) -> Result(wisp.Response, Nil) {
  req_body_parse(ctx, req, album_tag.json_decoder())
  |> result.try(db.album_tag_upsert(ctx, _))
  |> log.on_error(ctx, "could not upsert album_tag")
  |> result.replace(wisp.ok())
}

fn process_song_artist_get_all(
  ctx: context.Context,
) -> Result(wisp.Response, Nil) {
  db.song_artist_get_all(ctx)
  |> log.on_error(ctx, "could not get all song_artist")
  |> result.map(json.array(_, song_artist.to_json))
  |> result.map(json_to_response)
}

fn process_song_artist_delete(
  ctx: context.Context,
  req: wisp.Request,
) -> Result(wisp.Response, Nil) {
  req_body_parse(ctx, req, song_artist.json_decoder())
  |> result.try(db.song_artist_delete(ctx, _))
  |> log.on_error(ctx, "could not delete song_artist")
  |> result.replace(wisp.ok())
}

fn process_song_artist_upsert(
  ctx: context.Context,
  req: wisp.Request,
) -> Result(wisp.Response, Nil) {
  req_body_parse(ctx, req, song_artist.json_decoder())
  |> result.try(db.song_artist_upsert(ctx, _))
  |> log.on_error(ctx, "could not upsert song_artist")
  |> result.replace(wisp.ok())
}

fn process_album_artist_get_all(
  ctx: context.Context,
) -> Result(wisp.Response, Nil) {
  db.album_artist_get_all(ctx)
  |> log.on_error(ctx, "could not get all album_artist")
  |> result.map(json.array(_, album_artist.to_json))
  |> result.map(json_to_response)
}

fn process_album_artist_delete(
  ctx: context.Context,
  req: wisp.Request,
) -> Result(wisp.Response, Nil) {
  req_body_parse(ctx, req, album_artist.json_decoder())
  |> result.try(db.album_artist_delete(ctx, _))
  |> log.on_error(ctx, "could not delete album_artist")
  |> result.replace(wisp.ok())
}

fn process_album_artist_upsert(
  ctx: context.Context,
  req: wisp.Request,
) -> Result(wisp.Response, Nil) {
  req_body_parse(ctx, req, album_artist.json_decoder())
  |> result.try(db.album_artist_upsert(ctx, _))
  |> log.on_error(ctx, "could not upsert album_artist")
  |> result.replace(wisp.ok())
}
