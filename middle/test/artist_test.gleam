import gleam/json
import middle/artist

pub fn to_from_json_test() {
  let artist = artist.Artist(artist.Id(1), "KIZ")
  let assert Ok(out) =
    artist
    |> artist.to_json()
    |> json.to_string
    |> json.parse(artist.json_decoder())

  assert out == artist
}
