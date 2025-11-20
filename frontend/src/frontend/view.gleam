import frontend/message
import frontend/model
import lustre/attribute as attr
import lustre/element
import lustre/element/html

pub fn view(model: model.Model) -> element.Element(message.Message) {
  html.div([attr.class("w-screen h-screen bg-red-200")], [
    element.text("Hello World"),
  ])
}
