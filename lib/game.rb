# frozen_string_literal: true

class Game
  include Validation
  attr_accessor :attempts, :attempts_used, :hints, :hints_used, :levels, :name, :level_num
  attr_accessor :arr_index, :result
  attr_accessor :user_code, :secret_code, :phrases

  GAME_LEVELS = {
    easy: { attempts: 30, hints: 3, level_num: 0 },
    medium: { attempts: 15, hints: 2, level_num: 1 },
    hard: { attempts: 10, hints: 1, level_num: 2 }
  }.freeze

  DIGITS_COUNT = 4

  def new_game
    @secret_code = Array.new(DIGITS_COUNT) { rand(1..6) }
    @user_code = []
    @attempts_used = 0
    @hints_used = 0
  end

  def choose_level(levels)
    @levels = levels
    return unless validate_level(@levels)
    @attempts = GAME_LEVELS.dig(levels.to_sym, :attempts)
    @hints = GAME_LEVELS.dig(levels.to_sym, :hints)
    @level_num = GAME_LEVELS.dig(levels.to_sym, :level_num)
    @arr_index = (0..3).to_a.sample @hints
  end

  def choose_name(name)
    @name = name
    validate_name(@name)
  end

  def check_code(user_answer)
    secret_code.join == user_answer
  end

  def take_attempts
    @attempts -= 1
    @attempts_used += 1
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
end
