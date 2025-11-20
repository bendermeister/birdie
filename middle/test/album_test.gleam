import gleam/json
import middle/album

pub fn to_from_json_test() {
  let album = album.Album(id: album.Id(1), name: "the album")

  let assert Ok(out) =
    album
    |> album.to_json
    |> json.to_string
    |> json.parse(album.json_decoder())

  assert out == album
}
