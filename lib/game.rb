# frozen_string_literal: true

class Game
  include Validation
  attr_reader :attempts, :hints, :levels, :name, :level_num
  attr_reader :hints_index, :result
  attr_reader :user_code, :secret_code, :phrases
  RANGE = (1..6).freeze

  GAME_LEVELS = {
    easy: { attempts: 30, hints: 3, level_num: 0 },
    medium: { attempts: 15, hints: 2, level_num: 1 },
    hard: { attempts: 10, hints: 1, level_num: 2 }
  }.freeze

  DIGITS_COUNT = 4

  def new_game
    @secret_code = Array.new(DIGITS_COUNT) { rand(RANGE) }
  end

  def set_user_code(enter_code)
    @user_code = enter_code.each_char.map(&:to_i)
  end

  def enter_level(levels)
    return unless validate_level(levels)

    @levels = levels

    @attempts = GAME_LEVELS.dig(levels.to_sym, :attempts)
    @hints = GAME_LEVELS.dig(levels.to_sym, :hints)
    @level_num = GAME_LEVELS.dig(levels.to_sym, :level_num)
    @hints_index = (0..3).to_a.sample @hints
  end

  def enter_name(name)
    return unless validate_name(name)

    @name = name
  end

  def code?(user_answer)
    secret_code.join == user_answer
  end

  def take_attempts
    @attempts -= 1
  end

  def take_hints
    @hints -= 1
  end

  def game_result
    result = ''
    (0..3).each do |index|
      result += '+' if @user_code[index] == @secret_code[index]
    end
    return result if result.eql?('++++')
    (0..3).each do |index|
      result += '-' if @secret_code.include?(@user_code[index]) && @user_code[index] != @secret_code[index]
    end
    result
  end

  def save
    di = DatabaseInterceptor.new
    codebreaker_data = di.read_database || []
    attempts_used = GAME_LEVELS.dig(levels.to_sym, :attempts) - attempts
    hints_used = GAME_LEVELS.dig(levels.to_sym, :hints) - hints
    hash_stat = { name: @name, level: @levels, level_num: @level_num, attempts: @attempts, attempts_used: attempts_used, hints: @hints, hints_used: hints_used }
    codebreaker_data << hash_stat
    di.write_database(codebreaker_data)
  end
end
