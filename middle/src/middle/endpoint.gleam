import gleam/dynamic/decode
import gleam/int
import gleam/json
import gleam/result
import middle/query
import middle/song
import middle/tag
import wisp
import youid/uuid

pub type Endpoint {
  Query(page: Int, query: query.Query)

  TagGet
  TagDelete(id: tag.Id)
  TagUpdate(tag: tag.Tag)

  SongDelete(id: song.Id)
  SongUpdate(song: song.Song)
}

pub type Error {
  NotFound
  BadRequest
}

pub type Request {
  Get(url: String)
  Post(url: String, body: json.Json)
}

pub fn parse(request: wisp.Request) -> Result(Endpoint, Error) {
  let path =
    request
    |> wisp.path_segments()

  case path {
    ["api", "query", page] -> parse_query(request, page)

    // Tag Endpoints
    ["api", "tag", "get"] -> TagGet |> Ok
    ["api", "tag", "delete", id] -> parse_tag_delete(id)
    ["api", "tag", "update"] -> parse_tag_update(request)

    // Song Endpoints
    ["api", "song", "delete", id] -> parse_song_delete(id)
    ["api", "song", "update"] -> parse_song_update(request)

    _ -> Error(NotFound)
  }
}

pub fn to_request(endpoint: Endpoint) -> Request {
  case endpoint {
    // Query Endpoint
    Query(page:, query:) -> {
      let url = "/api/query/" <> int.to_string(page)
      let body = query |> query.to_json()
      Post(url:, body:)
    }

    // Tag Endpoints
    TagDelete(id:) -> { "/api/tag/delete/" <> uuid.to_string(id.inner) } |> Get
    TagGet -> "/api/tag/get" |> Get
    TagUpdate(tag:) -> {
      let url = "/api/tag/update"
      let body = tag |> tag.to_json()
      Post(url:, body:)
    }

    // Song Endpoints
    SongDelete(id:) ->
      { "/api/song/delete/" <> uuid.to_string(id.inner) } |> Get
    SongUpdate(song:) -> {
      let url = "/api/song/update"
      let body = song |> song.to_json()
      Post(url:, body:)
    }
  }
}

fn parse_json_body(
  request: wisp.Request,
  decoder: decode.Decoder(a),
) -> Result(a, Error) {
  request
  |> wisp.read_body_bits()
  |> result.try(fn(body) {
    body
    |> json.parse_bits(decoder)
    |> result.replace_error(Nil)
  })
  |> result.replace_error(BadRequest)
}

fn parse_query(request: wisp.Request, page: String) -> Result(Endpoint, Error) {
  let query = parse_json_body(request, query.json_decoder())
  use query <- result.try(query)

  let page = page |> int.parse() |> result.replace_error(BadRequest)
  use page <- result.try(page)

  Query(page:, query:)
  |> Ok
}

fn parse_tag_delete(id: String) -> Result(Endpoint, Error) {
  id
  |> uuid.from_string()
  |> result.map(tag.Id)
  |> result.map(TagDelete)
  |> result.replace_error(BadRequest)
}

fn parse_tag_update(request: wisp.Request) -> Result(Endpoint, Error) {
  request
  |> parse_json_body(tag.json_decoder())
  |> result.map(TagUpdate)
}

fn parse_song_update(request: wisp.Request) -> Result(Endpoint, Error) {
  request
  |> parse_json_body(song.json_decoder())
  |> result.map(SongUpdate)
}

fn parse_song_delete(id: String) -> Result(Endpoint, Error) {
  id
  |> uuid.from_string()
  |> result.map(song.Id)
  |> result.map(SongDelete)
  |> result.replace_error(BadRequest)
}
