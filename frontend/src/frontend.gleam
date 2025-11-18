import frontend/audio
import gleam/int
import gleam/io
import lustre
import lustre/attribute as attr
import lustre/effect
import lustre/element
import lustre/element/html
import lustre/event

pub fn main() -> Nil {
  let app = lustre.application(init, update, view)
  let assert Ok(_) = lustre.start(app, "#app", Nil)
  io.println("Hello from frontend!")
}

fn init(_args) -> #(Model, effect.Effect(Message)) {
  #(Model(audio.new("/rap.opus")), effect.none())
}

fn update(model: Model, message: Message) -> #(Model, effect.Effect(Message)) {
  case message {
    Pause -> {
      let audio = model.audio |> audio.pause()
      let model = Model(audio:)
      #(model, effect.none())
    }
    Play -> {
      let audio = model.audio |> audio.play()
      let model = Model(audio:)
      #(model, effect.none())
    }
  }
}

type Model {
  Model(audio: audio.Audio)
}

type Message {
  Pause
  Play
}

fn view(model: Model) -> element.Element(Message) {
  html.div(
    [attr.class("w-screen h-screen flex justify-center items-center gap-4")],
    [
      html.div(
        [
          attr.class("hover:cursor-pointer"),
          attr.class("bg-blue-700 text-white"),
          attr.class("rounded-xl p-5"),
          event.on_click(Pause),
        ],
        [
          element.text("Pause"),
        ],
      ),
      html.div(
        [
          attr.class("hover:cursor-pointer"),
          attr.class("bg-blue-700 text-white"),
          attr.class("rounded-xl p-5"),
          event.on_click(Play),
        ],
        [
          element.text("Play"),
        ],
      ),
    ],
  )
}
