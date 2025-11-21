import frontend/component
import frontend/message
import frontend/model
import frontend/route
import lustre/attribute as attr
import lustre/element
import lustre/element/html
import middle/album
import middle/song

pub fn view(model: model.Model) -> element.Element(message.Message) {
  html.div(
    [
      attr.class(
        "w-screen h-screen flex flex-col bg-overlay text-text font-serif gap-2",
      ),
    ],
    [
      component.header(),
      html.text(model.route |> route.to_uri |> fn(uri) { uri.path }),
      component.album(
        album.Album(id: album.Id(-1), name: "My total cool album"),
        model,
      ),
    ],
  )
}
