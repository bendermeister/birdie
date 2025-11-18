import dot_env
import dot_env/env
import gleam/erlang/process
import gleam/option
import gleam/otp/static_supervisor as supervisor
import pog
import wisp

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

  let assert Ok(db_host) = env.get_string("BIRDIE_DB_HOST")
  let assert Ok(db_port) = env.get_int("BIRDIE_DB_PORT")
  let assert Ok(db_user) = env.get_string("BIRDIE_DB_USER")
  let assert Ok(db_password) = env.get_string("BIRDIE_DB_PASSWORD")
  let assert Ok(db_database) = env.get_string("BIRDIE_DB_DATABASE")

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

  process.sleep_forever()
}
