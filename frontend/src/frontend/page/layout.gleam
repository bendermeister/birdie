import frontend/component
import frontend/icon
import frontend/message
import frontend/route
import lustre/attribute as attr
import lustre/element/html
import lustre/event

pub fn header() {
  let header_item = fn(icon, title, route) {
    html.div(
      [
        attr.class(
          "flex flex-row gap-2 justify-start items-center text-foam font-bold text-lg hover:cursor-pointer",
        ),
        event.on_click(message.UserChangeRoute(route)),
      ],
      [icon([attr.class("text-iris size-6")]), title |> html.text()],
    )
  }

  html.div(
    [
      attr.class("w-full h-[5rem] p-5"),
      attr.class("bg-overlay shadow-lg"),
      attr.class("flex flex-row justify-between items-center"),
    ],
    [
      component.birdie_logo(),
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

pub fn view(children) {
  html.div(
    [attr.class("w-screen h-screen flex flex-col bg-base text-text font-serif")],
    [
      header(),
      html.div([attr.class("h-[calc(100dvh-5rem)] p-5 w-full")], children),
    ],
  )
}
