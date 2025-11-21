import frontend/icon
import frontend/message
import frontend/model
import frontend/route
import gleam/dict
import gleam/list
import gleam/option
import gleam/pair
import gleam/result
import gleam/string
import lustre/attribute as attr
import lustre/element
import lustre/element/html
import lustre/event
import middle/album
import middle/query
import middle/song

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

pub fn album(album: album.Album, model: model.Model) {
  let artist =
    album.id
    |> dict.get(model.album_artist, _)
    |> result.unwrap([])
    |> list.map(fn(x) { x.artist_id })
    |> list.map(dict.get(model.artist, _))
    |> result.partition
    |> pair.first
    |> list.map(fn(x) { x.name })
    |> string.join(", ")
    |> string.to_option()
    |> option.unwrap("<unknown>")

  let title = album.name <> " -- " <> artist

  html.div(
    [
      attr.class("w-full px-5 py-2 rounded-lg bg-base"),
      attr.class("flex flex-row justify-between items-center"),
    ],
    [
      html.div([attr.class("flex flex-row justify-start items-center gap-2")], [
        icon.folder([attr.class("size-6 text-iris")]),
        html.div([attr.class("truncate")], [title |> html.text]),
      ]),
      html.div([attr.class("flex flex-row justify-end items-center gap-2")], [
        icon.play([attr.class("hover:cursor-pointer size-6 text-foam")]),
        icon.plus([attr.class("hover:cursor-pointer size-6 text-rose")]),
        icon.ellipsis([
          attr.class("hover:cursor-pointer size-6 text-muted"),
          album.id
            |> route.AlbumEdit
            |> message.UserChangeRoute
            |> event.on_click(),
        ]),
      ]),
    ],
  )
}

pub fn song(song: song.Song, model: model.Model) {
  let artist =
    model.song_artist
    |> dict.get(song.id)
    |> result.unwrap([])
    |> list.map(fn(x) { x.artist_id |> dict.get(model.artist, _) })
    |> result.partition()
    |> pair.first()
    |> list.unique()
    |> list.map(fn(x) { x.name })
    |> string.join(", ")
    |> string.to_option()
    |> option.unwrap("<unknown>")

  let title = song.name <> " -- " <> artist

  html.div(
    [
      attr.class("w-full px-5 py-2 rounded-lg bg-base"),
      attr.class("flex flex-row justify-between items-center"),
    ],
    [
      html.div([attr.class("flex flex-row justify-start items-center gap-2")], [
        icon.music_note([attr.class("size-6 text-iris")]),
        html.div([attr.class("truncate")], [title |> html.text]),
      ]),
      html.div([attr.class("flex flex-row justify-end items-center gap-2")], [
        icon.play([attr.class("hover:cursor-pointer size-6 text-foam")]),
        icon.plus([attr.class("hover:cursor-pointer size-6 text-rose")]),
        icon.ellipsis([
          attr.class("hover:cursor-pointer size-6 text-muted"),
          song.id
            |> route.MusicEdit
            |> message.UserChangeRoute
            |> event.on_click(),
        ]),
      ]),
    ],
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
