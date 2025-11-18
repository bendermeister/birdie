import pog
import youid/uuid

pub type Context {
  Context(id: uuid.Uuid, db: pog.Connection)
}
