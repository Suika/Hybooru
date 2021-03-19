
DROP TABLE IF EXISTS meta CASCADE;
CREATE TABLE meta (
  id INTEGER PRIMARY KEY DEFAULT 39,
  hash INTEGER DEFAULT 0
);

INSERT INTO meta DEFAULT VALUES;

CREATE OR REPLACE FUNCTION format_date(TIMESTAMPTZ) RETURNS TEXT
  AS $$ SELECT to_char($1 AT TIME ZONE 'UTC', 'YYYY-MM-DD"T"HH24:MI:SS.MS"Z"'); $$
  LANGUAGE SQL
  IMMUTABLE
  RETURNS NULL ON NULL INPUT;

DROP TABLE IF EXISTS global CASCADE;
CREATE TABLE global (
  id INTEGER PRIMARY KEY DEFAULT 39,
  thumbnail_width INTEGER NOT NULL,
  thumbnail_height INTEGER NOT NULL,
  posts INTEGER NOT NULL,
  tags INTEGER NOT NULL,
  mappings INTEGER NOT NULL,
  needs_tags INTEGER NOT NULL
);

DROP TABLE IF EXISTS posts CASCADE;
CREATE TABLE posts (
  id INTEGER PRIMARY KEY,
  hash BYTEA NOT NULL UNIQUE,
  size INTEGER,
  width INTEGER,
  height INTEGER,
  duration FLOAT,
  num_frames INTEGER,
  has_audio BOOLEAN,
  rating FLOAT,
  mime INTEGER,
  posted TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

DROP TABLE IF EXISTS urls CASCADE;
CREATE TABLE urls (
  id INTEGER,
  postid INTEGER NOT NULL REFERENCES posts(id) ON DELETE CASCADE,
  url TEXT NOT NULL,

  PRIMARY KEY(id, postid)
);

DROP TABLE IF EXISTS tags CASCADE;
CREATE TABLE tags (
  id INTEGER PRIMARY KEY,
  name TEXT NOT NULL,
  subtag TEXT NOT NULL,
  used INTEGER NOT NULL
);

DROP TABLE IF EXISTS namespaces CASCADE;
CREATE TABLE namespaces (
  id INTEGER PRIMARY KEY,
  name TEXT,
  color TEXT NOT NULL
);

DROP TABLE IF EXISTS mappings CASCADE;
CREATE TABLE mappings (
  postid INTEGER NOT NULL REFERENCES posts(id) ON DELETE CASCADE,
  tagid INTEGER NOT NULL REFERENCES tags(id) ON DELETE CASCADE,

  PRIMARY KEY(postid, tagid)
);
