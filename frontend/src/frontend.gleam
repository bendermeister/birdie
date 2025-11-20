import frontend/init
import frontend/update
import frontend/view
import gleam/io
import lustre

pub fn main() -> Nil {
  let app = lustre.application(init.init, update.update, view.view)
  let assert Ok(_) = lustre.start(app, "#app", Nil)
  io.println("Main EXIT")
  Nil
}
