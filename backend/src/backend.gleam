import backend/context
import backend/web
import dot_env
import dot_env/env
import gleam/erlang/process
import gleam/option
import gleam/otp/static_supervisor as supervisor
import mist
import pog
import wisp
import wisp/wisp_mist
import youid/uuid

pub fn start_application_supervisor(
  name pool_name: process.Name(pog.Message),
  host host: String,
  port port: Int,
  user user: String,
  password password: String,
  database database: String,
) {
  let pool_child =
    pog.default_config(pool_name)
    |> pog.host(host)
    |> pog.port(port)
    |> pog.password(option.Some(password))
    |> pog.user(user)
    |> pog.database(database)
    |> pog.pool_size(16)
    |> pog.supervised()

  supervisor.new(supervisor.RestForOne)
  |> supervisor.add(pool_child)
  |> supervisor.start
}

pub fn main() -> Nil {
  dot_env.new()
  |> dot_env.set_path("./.env")
  |> dot_env.set_debug(False)
  |> dot_env.load()

  // DB ENV variables
  let assert Ok(db_host) = env.get_string("BIRDIE_DB_HOST")
  let assert Ok(db_port) = env.get_int("BIRDIE_DB_PORT")
  let assert Ok(db_user) = env.get_string("BIRDIE_DB_USER")
  let assert Ok(db_password) = env.get_string("BIRDIE_DB_PASSWORD")
  let assert Ok(db_database) = env.get_string("BIRDIE_DB_DATABASE")

  // Server ENV variables
  let assert Ok(server_port) = env.get_int("BIRDIE_PORT")
  let assert Ok(server_host) = env.get_string("BIRDIE_HOST")

  let db = process.new_name("db")
  let assert Ok(_) =
    start_application_supervisor(
      name: db,
      host: db_host,
      port: db_port,
      user: db_user,
      password: db_password,
      database: db_database,
    )

  wisp.configure_logger()

  let request_handler = fn(req: wisp.Request) {
    let db = pog.named_connection(db)
    let ctx = context.Context(id: uuid.v4(), db:)
    web.handle_request(ctx, req)
  }
  let secret_key = wisp.random_string(64)

  let assert Ok(_) =
    wisp_mist.handler(request_handler, secret_key)
    |> mist.new()
    |> mist.port(server_port)
    |> mist.bind(server_host)
    |> mist.start()

  process.sleep_forever()
}
