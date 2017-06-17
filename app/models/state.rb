class State < ActiveRecord::Base
  self.table_name = "markov"
  attr_accessor :left, :right, :occurrences, :left_size, :right_size, :sentence_end
  
  
  def self.speak(left, amount = 200, left_max_size = 7, right_max_size = 7)
    result = left.to_s.split(" ")
    (0 .. amount).each do
      (1 .. left_max_size).to_a.reverse.each do |try_size|
        try_word = result.last(try_size).join(" ").delete(".")
        row = State.connection.raw_connection.prepare("SELECT right, sentence_end FROM markov WHERE left = ? AND right_size <= ? ORDER BY RANDOM() ASC LIMIT 1")
        row = row.execute(try_word, right_max_size). next
        if !row.nil?
          result << row[0].split(" ")
          result.flatten!
          result[result.length - 1] = result.last + "." if row[1] == 1
          break;
        end
      end
    end

    result = result.join(" ")
    dot_split = result.split(".")
    result = dot_split.first + "." + dot_split[1 .. -1].inject(""){|sum, str| sum += " " + str[1 .. -1].capitalize + ".";sum}
    result
  end
end