# frozen_string_literal: true

class Game
  include Validation
  attr_reader :attempts, :attempts_used, :hints, :hints_used, :levels, :name, :level_num
  attr_reader :arr_index, :result
  attr_accessor :user_code, :secret_code, :phrases
  def initialize
    phrases_db = Db.new('./data/help.yml')
    @phrases = phrases_db.read_database
  end

  def new_game
    puts @phrases['choose_difficulty']
    @levels = gets.chomp
    new_game unless choose_level
    new_code
    round_game
  end

  def new_code
    @secret_code = [rand(1...6), rand(1...6), rand(1...6), rand(1...6)]
    @user_code = []
    @attempts_used = 0
    @hints_used = 0
  end

  def choose_level
    return unless validate_level(@levels)

    level_game = {
      easy: { attempts: 30, hints: 3, level_num: 0 },
      medium: { attempts: 15, hints: 2, level_num: 1 },
      hard: { attempts: 10, hints: 1, level_num: 2 }
    }
    @attempts = level_game.dig(levels.to_sym, :attempts)
    @hints = level_game.dig(levels.to_sym, :hints)
    @level_num = level_game.dig(levels.to_sym, :level_num)
    @arr_index = (0..3).to_a.sample @hints
  end

  def choose_name
    puts @phrases['username']
    @name = $stdin.gets.chomp
    puts @phrases['hello'] + @name
    return if validate_name(@name)

    choose_name
  end

  def round_game
    if @attempts.positive?
      puts format(@phrases['question_num'], @attempts, @hints)
      @attempts -= 1
      @attempts_used += 1
      user_answer = gets.chomp
      hint_show if user_answer == 'hint'
      puts @phrases['invalid_number'] unless validate_answer(user_answer)
      @user_code = user_answer.each_char.map(&:to_i)
      if check_code(user_answer)
        win
      else
        puts game_result
        round_game
      end
    else
      loose
    end
  end

  def check_code(user_answer)
    secret_code.join == user_answer
  end

  def game_result
    result = ''
    (0..3).each do |index|
      result += '+' if @user_code[index] == @secret_code[index]
    end
    (0..3).each do |index|
      if @secret_code.include?(@user_code[index]) && @user_code[index] != @secret_code[index]
        result += '-' unless result.eql?('++++')
      end
    end
    result
  end

  def hint_show
    if hints.zero?
      puts @phrases['over_hint']
      round_game
    end
    secret_code.map.with_index do |element, index|
      if index == @arr_index[hints - 1]
        print element
      else
        print '*'
      end
    end
    print "\n"
    @hints -= 1 if @hints > 0
    @hints_used += 1 if @hints > 0
    round_game
  end

  def win
    db = Db.new
    codebreaker_data = db.read_database
    puts game_result
    puts @phrases['win']
    puts @phrases['progress']
    your_want_save = gets.chomp
    if your_want_save.eql? 'yes'
      hash_stat = { name: @name, level: @levels, level_num: @level_num, attempts: @attempts, attempts_used: @attempts_used, hints: @hints, hints_used: @hints_used }
      codebreaker_data = [] if codebreaker_data.nil?
      codebreaker_data << hash_stat
      db.write_database(codebreaker_data)
    end
    puts @phrases['new_game']
    your_want_new_game = gets.chomp
    exit unless your_want_new_game.eql? 'yes'
    new_game if your_want_new_game.eql? 'yes'
  end

  def loose
    puts @phrases['lose']
    puts @phrases['code_was']
    @secret_code.each do |value|
      print value
    end
    puts
    puts @phrases['new_game']
    your_want_new_game = gets.chomp
    exit unless your_want_new_game.eql? 'yes'
    new_game if your_want_new_game.eql? 'yes'
  end

  def stats
    db = Db.new
    codebreaker_data = db.read_database
    puts @phrases['empty_stat'] unless codebreaker_data
    puts @phrases['stats']
    puts @phrases['col_table']
    raiting = 0
    codebreaker_data.sort_by! { |stat| [stat[:level_num], stat[:hints], stat[:attempts]] }
    codebreaker_data.each do |stat|
      raiting += 1
      print "#{raiting}\t"
      stat.each do |key, value|
        next if key.eql?('level_num')

        print "#{value}\t"
      end
      print "\n"
    end
  end
end
