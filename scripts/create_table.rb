#!/usr/bin/env ruby
require "sqlite3"

db = SQLite3::Database.new "database.db"
rows = db.execute <<-SQL
BEGIN;
CREATE TABLE IF NOT EXISTS markov(
	left text NOT NULL,
	right text NOT NULL,
	occurrences int NOT NULL,
  left_size int NOT NULL,
  right_size int NOT NULL,
  sentence_end bool NOT NULL
);

CREATE INDEX left_index on markov(left);
CREATE INDEX left_right_index on markov(left, right);
CREATE INDEX occurrences_index on markov(occurrences);
CREATE INDEX left_right_size_index on markov(left, right_size);
COMMIT;
SQL
