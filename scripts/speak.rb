#!/usr/bin/env ruby
require "sqlite3"


db = SQLite3::Database.new "../db/database.db"
result = ARGV[0].to_s.split(" ")
amount = (ARGV[1] || 50).to_i
LEFT_MAX_SIZE = (ARGV[2] || 7).to_i
RIGHT_MAX_SIZE = (ARGV[3] || 7).to_i

(0 .. amount).each do
  (1 .. LEFT_MAX_SIZE).to_a.reverse.each do |try_size|
    try_word = result.last(try_size).join(" ").delete(".")
    rows = db.execute("SELECT right, sentence_end FROM markov WHERE left = ? AND right_size <= ? ORDER BY RANDOM() ASC LIMIT 1", try_word, RIGHT_MAX_SIZE)
    if !rows.empty? && !rows[0].empty?
      result << rows[0][0].split(" ")
      result.flatten!
      result[result.length - 1] = result.last + "." if rows[0][1] == 1
      break;
    end
  end
end

result = result.join(" ")
dot_split = result.split(".")
result =dot_split.first + "." + dot_split[1 .. -1].inject(""){|sum, str| sum += " " + str[1 .. -1].capitalize + ".";sum}
puts result
