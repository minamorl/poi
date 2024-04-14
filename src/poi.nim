import db_connector/db_sqlite
import uuids
import std/parseopt
import std/os, std/strutils, std/strutils, std/sequtils


let db = open("test.db", "", "", "")

proc createTable(db: DBConn) =
  db.exec(sql"""
  CREATE TABLE IF NOT EXISTS documents (
    id CHAR(36) PRIMARY KEY,
    content TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
  );
  """)

proc insertDocument(db: DBConn, id: string, content: string) =
  db.exec(sql"""
  INSERT INTO documents (id, content) VALUES (?, ?);
  """, id, content)
  

# create table if not exists
db.createTable()


proc insertMode() =
  let input = stdin.readAll()
  db.insertDocument($uuids.genUUID(), input)

proc showMode() =
  echo "here"
  for row in db.rows(sql"SELECT id, content, created_at FROM documents"):
    echo row

var p = initOptParser()
while true:
  p.next()
  case p.kind
  of cmdEnd: break
  of cmdShortOption, cmdLongOption:
    case p.key
    of "show":
      showMode()
    of "insert":
      insertMode()
    else:
      echo "Unknown option: ", p.key
  of cmdArgument:
    echo "Unknown argument: ", p.val

