import frontend/icon
import lustre/attribute as attr
import lustre/element/html

pub fn view() {
  html.div([attr.class("w-full px-20")], [
    html.form(
      [
        attr.class(
          "w-full bg-overlay shadow-lg rounded-lg p-5 flex flex-col gap-4",
        ),
      ],
      [
        html.h1(
          [
            attr.class("w-full"),
            attr.class("flex flex-row"),
            attr.class("justify-start items-center gap-4"),
            attr.class("font-bold text-xl text-foam"),
          ],
          [
            icon.music_note([attr.class("text-iris size-8")]),
            html.text("new song"),
          ],
        ),
        html.div([attr.class("w-full flex flex-col gap-2")], [
          html.div([attr.class("text-subtle")], [
            html.text("song title"),
          ]),
          html.input([
            attr.class("appearance-none"),
            attr.class("outline-none focus:outline-none hover:outline-none"),
            attr.class("border-none focus:border-none hover:border-none"),
            attr.class("p-2 rounded-lg bg-base"),
          ]),
        ]),
      ],
    ),
  ])
}
