import gleam/json
import middle/album
import middle/album_tag
import middle/tag
import youid/uuid

pub fn to_from_json_test() {
  let x =
    album_tag.AlbumTag(album_id: album.Id(uuid.v4()), tag_id: tag.Id(uuid.v4()))
  let assert Ok(out) =
    x
    |> album_tag.to_json()
    |> json.to_string()
    |> json.parse(album_tag.json_decoder())
  assert x == out
}
