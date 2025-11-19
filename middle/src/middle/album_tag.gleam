import gleam/dynamic/decode
import gleam/json
import middle/album
import middle/tag

pub type AlbumTag {
  AlbumTag(album_id: album.Id, tag_id: tag.Id)
}

pub fn to_json(x: AlbumTag) {
  [
    #("album_id", x.album_id |> album.id_to_json()),
    #("tag_id", x.tag_id |> tag.id_to_json()),
  ]
  |> json.object()
}

pub fn json_decoder() {
  use album_id <- decode.field("album_id", album.id_decoder())
  use tag_id <- decode.field("tag_id", tag.id_decoder())
  AlbumTag(album_id:, tag_id:) |> decode.success()
}
