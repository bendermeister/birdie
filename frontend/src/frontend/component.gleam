import frontend/icon
import frontend/message
import frontend/route
import gleam/list
import gleam/pair
import lustre/attribute as attr
import lustre/element
import lustre/element/html
import lustre/event
import middle/query

pub fn birdie_logo() {
  html.div(
    [
      attr.class(
        "text-[2rem] font-bold font-serif text-outline-love text-rose hover:cursor-pointer",
      ),
      event.on_click(message.UserChangeRoute(route.Home)),
    ],
    [element.text("birdie")],
  )
}

pub fn text_input(attrs) {
  html.input([
    attr.type_("text"),
    attr.class("outline-none hover:outline-none focus:outline-none"),
    attr.class("border-none hover:border-none, focus:border-none"),
    attr.class("bg-base rounded-lg p-2"),
    ..attrs
  ])
}

pub fn query_box(query: query.Query) {
  let parts =
    query.query
    |> list.map(query_part(_, []))

  html.div(
    [
      attr.class(
        "w-[30rem] rounded-lg p-5 bg-overlay shadow-lg flex flex-col gap-4",
      ),
    ],
    [
      html.div([attr.class("w-full")], [
        text_input([attr.placeholder("search..."), attr.class("w-full")]),
      ]),
      html.div(
        [attr.class("flex gap-2 flex-wrap flex-grow max-w-full w-full")],
        parts,
      ),
    ],
  )
}

pub fn header() {
  let header_item = fn(icon, title, route) {
    html.div(
      [
        attr.class(
          "flex flex-row gap-2 justify-start items-center text-foam font-bold text-lg hover:cursor-pointer",
        ),
        event.on_click(message.UserChangeRoute(route)),
      ],
      [icon([attr.class("text-iris size-6")]), title |> element.text()],
    )
  }

  html.div(
    [
      attr.class("w-full h-20 p-5"),
      attr.class("bg-overlay shadow-lg"),
      attr.class("flex flex-row justify-between items-center"),
    ],
    [
      birdie_logo(),
      html.div(
        [
          attr.class("w-full"),
          attr.class("flex flex-row gap-8 justify-end items-center"),
        ],
        [
          header_item(icon.music_note, "music", route.Music),
          header_item(icon.folder, "album", route.Album),
          header_item(icon.user, "artist", route.Artist),
          header_item(icon.tag, "tag", route.Tag),
        ],
      ),
    ],
  )
}

pub fn query_part(part: query.Part, attrs: List(attr.Attribute(a))) {
  let #(text, border) =
    case part {
      query.Artist(t) -> #(t, "border-gold")
      query.Tag(t) -> #(t, "border-foam")
      query.Title(t) -> #(t, "border-love")
    }
    |> pair.map_first(html.text)
    |> pair.map_second(attr.class)

  html.div(
    [
      border,
      attr.class(
        "flex flex-row gap-2 justify-start items-center rounded-lg border w-fit bg-base py-1 px-2",
      ),
      ..attrs
    ],
    [
      html.div([attr.class("max-w-20 truncate")], [text]),
      icon.x_mark([attr.class("hover:cursor-pointer size-5 text-text")]),
    ],
  )
}
