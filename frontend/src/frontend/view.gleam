import frontend/component
import frontend/message
import frontend/model
import frontend/route
import lustre/attribute as attr
import lustre/element
import lustre/element/html

pub fn view(model: model.Model) -> element.Element(message.Message) {
  html.div(
    [
      attr.class(
        "w-screen h-screen flex flex-col bg-base text-text font-serif gap-2",
      ),
    ],
    [
      component.header(),
      html.text(model.route |> route.to_uri |> fn(uri) { uri.path }),
    ],
  )
}
