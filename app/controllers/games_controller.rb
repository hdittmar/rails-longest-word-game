class GamesController < ApplicationController
  GRIDSIZE = 12
  require 'date'
  require 'open-uri'



  def new
    @i = Array(1..GRIDSIZE)
    @i.map! { ("A".."Z").to_a.sample }
    @start_time = Time.now;
  end

  def score
    # raise
    @attempt = params[:attempt]
    start_time = Time.parse(params[:time])
    # raise
    url = "https://wagon-dictionary.herokuapp.com/#{@attempt}"
    serialized = open(url).read
    api_result = JSON.parse(serialized)
    found = api_result["found"]
    false_flag = in_grid(@attempt, params[:grid])
    time_taken = (Time.now - start_time).to_i
    s_m_a = score_and_message(time_taken, false_flag, found, @attempt.length)
    @message = s_m_a[1]
    @score = s_m_a[0]
  end

  def in_grid(attempt, grid)
    false_flag = 0
    attempt.upcase.chars.each do |letter|
      if grid.index(letter)
        i = grid.index(letter)
        grid[i] = ""
      else
        false_flag = 1
      end
    end

    return false_flag
  end

  def score_and_message(time_taken, false_flag, found, l)
    score = 0
    if false_flag == 1
      message = "not in the grid"
    elsif found == true
      message = "well done"
      score = l
      score += (20 - time_taken) if time_taken < 20
    else
      message = "not an english word"
    end
    return [score, message]
  end

  # serialized = open(url).read
  # api_result = JSON.parse(serialized)
  # found = api_result["found"]
  # false_flag = in_grid(attempt, grid)
  # time_taken = (end_time - start_time).to_i
  # s_m_a = score_and_message(time_taken, false_flag, found, attempt.length)
  # { time: end_time - start_time, score: s_m_a[0], message: s_m_a[1] }

end
