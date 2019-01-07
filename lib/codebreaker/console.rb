# frozen_string_literal: true
module Codebreaker
  class Console

    COMMANDS = {
      start: 'start',
      rules: 'rules',
      stats: 'stats',
      exit: 'exit'
    }.freeze

    HINT = 'hint'

    ANSWERS = { yes: 'yes' }

    def launch
      loop do
        message(:start_game)
        message(:wel_instruct, COMMANDS)
        @answer = read_from_console
        check_answer
      end
    end

    def start_game
      @game = Codebreaker::Game.new
      enter_name
      enter_level
      @game.new_game
      round_game
    end

    def round_game
      while @game.attempts.positive?
        user_answer = message_game_read_console
        next hint_show if user_answer == HINT
        next message(:invalid_number) unless @game.validate_code(user_answer)

        @game.handle_guess(user_answer)
        return win if @game.equal_codes?(user_answer)

        message_game_result
      end
      loose
    end

    def hint_show
      return message(:over_hint) if @game.hints.zero?

      puts @game.show_hints
      @game.take_hints
    end

    def win
      message(:win)
      message(:progress)
      @game.save if read_from_console.eql? ANSWERS[:yes]
      continue_game? ? start_game : exit
    end

    def loose
      message(:lose)
      continue_game? ? start_game : exit
    end

    def continue_game?
      message(:new_game)
      read_from_console.eql? ANSWERS[:yes]
    end

    def stats_show
      @stat = Codebreaker::Statistics.new
      return message(:empty_stat) unless data = @stat.stats

      message(:stats)
      message(:col_table)
      data.each_with_index do |row, index|
        print "#{index}\t"
        row.each do |_key, cell|
          print "#{cell}\t"
        end
        print "\n"
      end
    end

    private

    def check_answer
      case @answer
      when COMMANDS[:start] then start_game
      when COMMANDS[:rules] then message(:rulegame)
      when COMMANDS[:stats] then stats_show
      when COMMANDS[:exit] then exit
      end
    end

    def message(msg, params = {})
      puts I18n.t(msg, params)
    end

    def read_from_console
      gets.chomp
    end

    def message_game_read_console
      message(:question_num, attempts: @game.attempts, hints: @game.hints)
      read_from_console
    end

    def message_game_result
      puts @game.game_result
    end

    def enter_name
      message(:username)
      return enter_name unless @game.enter_name(read_from_console)

      message(:hello, name: @game.name)
    end

    def enter_level
      message(:choose_difficulty, difficulties: Codebreaker::Game::GAME_LEVELS.keys.join(' '))
      return enter_level unless @game.enter_level(read_from_console)
    end
  end
end
