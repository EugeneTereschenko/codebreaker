# frozen_string_literal: true

module Codebreaker
  class Game
    include Validation
    attr_reader :attempts, :hints, :level, :name, :level_num
    attr_reader :hints_index, :result
    attr_reader :user_code, :secret_code, :phrases
    RANGE = (1..6).freeze

    GAME_LEVELS = {
      easy: { attempts: 30, hints: 3, level_num: 0 },
      medium: { attempts: 15, hints: 2, level_num: 1 },
      hard: { attempts: 10, hints: 1, level_num: 2 }
    }.freeze

    COUNTS_OF_HINTS = 0..3.freeze
    DIGITS_COUNT = 4
    USER_ANSWER_REX = /^[1-6]{4}$/.freeze

    def new_game
      @secret_code = Array.new(DIGITS_COUNT) { rand(RANGE) }
    end

    def enter_level(level)
      return unless GAME_LEVELS.keys.include?(level.to_sym)
      @level = level

      @attempts = GAME_LEVELS.dig(level.to_sym, :attempts)
      @hints = GAME_LEVELS.dig(level.to_sym, :hints)
      @level_num = GAME_LEVELS.dig(level.to_sym, :level_num)
      @hints_index = (COUNTS_OF_HINTS).to_a.sample @hints
    end

    def enter_name(name)
      return unless validate_length(name)

      @name = name
    end

    def equal_codes?(user_answer)
      secret_code.join == user_answer
    end

    def take_attempts
      @attempts -= 1
    end

    def take_hints
      @hints -= 1
    end

    def show_hints
      secret_code[hints_index.shift]
    end

    def set_user_code(enter_code)
      @user_code = enter_code.each_char.map(&:to_i)
    end

    def handle_guess(user_answer)
      take_attempts
      set_user_code(user_answer)
    end

    def game_result
      return '++++' if equal_codes?(@user_code.join)

      result = ''
      @secret_code_clone = @secret_code.clone
      @user_code.each_with_index do |digit, index|
        next unless digit == @secret_code_clone[index]

        result += '+'
        @secret_code_clone[index] = nil
        @user_code[index] = nil
      end
      
      @user_code.compact.each_with_index do |digit, index|
        next unless @secret_code_clone.include?(digit)

        result += '-'
        @secret_code_clone[@secret_code_clone.index(digit)] = nil
      end
      result
    end

    def storage_data(codebreaker_data)
      attempts_used = GAME_LEVELS.dig(level.to_sym, :attempts) - attempts
      hints_used = GAME_LEVELS.dig(level.to_sym, :hints) - hints
      hash_stat = { name: @name, level: @level, level_num: @level_num, attempts: @attempts, attempts_used: attempts_used, hints: @hints, hints_used: hints_used }
      codebreaker_data << hash_stat
    end

    def save
      storage = StorageInterceptor.new
      codebreaker_data = storage.read_database || []
      storage.write_database(storage_data(codebreaker_data))
    end
  end
end
