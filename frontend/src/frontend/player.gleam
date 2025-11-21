import frontend/audio
import frontend/icon
import lustre/attribute as attr
import lustre/element
import lustre/element/html
import middle/song

pub type Player {
  Player(
    audio: audio.Audio,
    song: song.Song,
    duration: Int,
    playtime: Int,
    state: State,
  )
}

pub type State {
  Pause
  Play
}

pub fn new(song: song.Song) -> Player {
  Player(
    audio: audio.new("/api/static/" <> song.file_name),
    song:,
    duration: 0,
    playtime: 0,
    state: Pause,
  )
  |> update()
}

pub fn update(player: Player) -> Player {
  Player(
    audio: player.audio,
    song: player.song,
    duration: audio.duration(player.audio),
    playtime: audio.playtime(player.audio),
    state: player.state,
  )
}

pub fn pause(player: Player) -> Player {
  let audio = player.audio |> audio.pause()
  let state = Pause
  Player(..player, audio:, state:)
  |> update()
}

pub fn player() {
  html.div(
    [
      attr.class("fixed bottom-0 z-20"),
      attr.class("flex justify-center items-center"),
      attr.class("w-full h-25"),
    ],
    [
      html.div(
        [
          attr.class("w-[50rem] h-20 p-2"),
          attr.class("bg-overlay shadow-lg rounded-lg"),
          attr.class("grid grid-cols-3"),
        ],
        [
          html.div(
            [
              attr.class("w-full h-full"),
              attr.class("flex flex-row justify-start items-center gap-4"),
            ],
            [
              icon.music_note([attr.class("size-8 text-iris")]),
              html.div(
                [attr.class("flex flex-col items-start justify-center h-full")],
                [
                  html.div([attr.class("text-lg")], [
                    element.text("Rap ueber Hass"),
                  ]),
                  html.div([attr.class("")], [element.text("K.I.Z")]),
                ],
              ),
            ],
          ),
          html.div(
            [
              attr.class("w-full h-full pt-2"),
              attr.class("flex flex-col"),
              attr.class("justify-center items-center gap-1"),
            ],
            [
              html.div(
                [attr.class("relative w-full h-5 rounded-lg bg-subtle")],
                [
                  html.div(
                    [
                      attr.class("absolute top-0 left-0"),
                      attr.class("rounded-lg bg-foam h-full w-[20%]"),
                    ],
                    [],
                  ),
                ],
              ),
              html.div(
                [
                  attr.class("flex flex-row"),
                  attr.class("justify-center items-center gap-2"),
                ],
                [
                  icon.backward([
                    attr.class("size-6 text-subtle hover:cursor-pointer"),
                  ]),
                  icon.play([
                    attr.class("size-6 text-subtle hover:cursor-pointer"),
                  ]),
                  icon.forward([
                    attr.class("size-6 text-subtle hover:cursor-pointer"),
                  ]),
                ],
              ),
            ],
          ),
          html.div(
            [attr.class("w-full h-full flex justify-end items-center flex-row")],
            [icon.bars([attr.class("size-8 text-muted hover:cursor-pointer")])],
          ),
        ],
      ),
    ],
  )
}
