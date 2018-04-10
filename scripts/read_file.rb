#!/usr/bin/env ruby
require "sqlite3"
LEFT_MAX_SIZE = 5
RIGHT_MAX_SIZE = 5
db = SQLite3::Database.new "../db/database.db"

file_path = ARGV[0]
str = File.read(file_path)
sentences = str.split(".")

sentences.each_with_index do |sentence, index|
  puts "Læser #{index + 1} / #{sentences.length} ..."# if index + 1 % 5 == 0
  words = sentence.split(" ")

  (0 .. words.length - 1).to_a.each do |word_index|
    (0 .. LEFT_MAX_SIZE).to_a.each do |left_size|
      current_left = words.slice(word_index, left_size)
      next if current_left.nil? || current_left.length == 0
      next if word_index + left_size > words.length

      (0 .. RIGHT_MAX_SIZE).each do |right_size|
        current_right = words.slice(word_index + left_size, right_size)
        next if current_right.nil? || current_right.length == 0
        next if word_index + left_size + right_size > words.length

        sentence_end = current_right.last == words.last ? 1 : 0
        if !current_right.nil? && !current_right.empty?
          rows = db.execute("SELECT * FROM markov WHERE left = ? AND right = ?", current_left.join(" "), current_right.join(" "))
          if rows.empty?
            db.execute("INSERT INTO markov VALUES (?, ?, ?, ?, ?, ?)", current_left.join(" "), current_right.join(" "), 1, current_left.size, current_right.size, sentence_end)
          else
            db.execute("UPDATE markov SET occurrences = occurrences + 1 WHERE  left = ? AND right = ?", current_left.join(" "), current_right.join(" "))
          end
        end
      end
    end
  end



  #  (0 .. words.length - 1).each do
  #    (0 .. words.length - 1).each do |word_index|
  #    end
  #  end
end
