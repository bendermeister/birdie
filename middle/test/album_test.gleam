import gleam/json
import middle/album
import youid/uuid

pub fn to_from_json_test() {
  let album = album.Album(id: album.Id(uuid.v4()), name: "the album")

  let assert Ok(out) =
    album
    |> album.to_json
    |> json.to_string
    |> json.parse(album.json_decoder())

  assert out == album
}
