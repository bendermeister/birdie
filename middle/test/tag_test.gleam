import gleam/json
import middle/tag
import youid/uuid

pub fn to_from_json_test() {
  let tag = tag.Tag(tag.Id(uuid.v4()), "rock")

  let assert Ok(out) =
    tag
    |> tag.to_json()
    |> json.to_string()
    |> json.parse(tag.json_decoder())

  assert out == tag
}
