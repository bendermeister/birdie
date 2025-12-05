import frontend/message
import frontend/model
import frontend/page/layout
import frontend/page/song_new
import frontend/player
import frontend/route
import lustre/element
import lustre/element/html

pub fn view(model: model.Model) -> element.Element(message.Message) {
  let default_view = model.route |> route.to_string |> html.text()

  layout.view([
    case model.route {
      route.Album -> default_view
      route.AlbumEdit(album_id:) -> default_view
      route.Artist -> default_view
      route.ArtistEdit(artist_id:) -> default_view
      route.Home -> default_view
      route.Music -> default_view
      route.MusicEdit(song_id:) -> default_view
      route.NotFound -> default_view
      route.Queue -> default_view
      route.Tag -> default_view
      route.TagEdit(tag_id:) -> default_view
      route.MusicNew -> song_new.view()
    },
    player.view_opt(model.player),
  ])
}
