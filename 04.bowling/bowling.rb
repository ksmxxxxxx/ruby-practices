#!/usr/bin/env ruby
# frozen_string_literal: true

def bowling_score(score)
  scores = score.chars
  shots = []
  frames = []
  point = 0

  scores.each do |s|
    if s == 'X'
      shots << 10
      shots << 0 if shots.size.odd?
    else
      shots << s.to_i
    end
  end

  shots.each_slice(2) do |s|
    p frames << s
  end

  frames.each_with_index do |frame, index|
    next_frame = index + 1
    if index <= 8
      if frame[0] == 10
        point += 10 + frames[next_frame][0]
        point += if frames[next_frame][0] == 10
                   frames[next_frame + 1][0]
                 else
                   frames[next_frame][1]
                 end
      elsif frame.sum == 10
        point += 10 + frames[next_frame][0]
      else
        point += frame.sum
      end
    else
      point += frame.sum
    end
  end

  p point
end

if __FILE__ == $PROGRAM_NAME
  score = ARGV[0]
  bowling_score(score)
end
