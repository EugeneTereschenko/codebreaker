module Codebreaker
class Console
    YES = 'yes'.freeze
    HINT = 'hint'.freeze
    START = 'start'.freeze
    RULES = 'rules'.freeze
    STATS = 'stats'.freeze
    EXIT = 'exit'.freeze

    DIFFICULTIES = %w[easy medium hard].freeze

    def initialize
      @game = Codebreaker::Game.new
      @stat = Codebreaker::Stats.new
    end

    def launch
      loop do
        message(:start_game)
        message(:wel_instruct, start: START, rules: RULES, stats: STATS, exit: EXIT)
        @answer = read_from_console
        check_answer
      end
    end

    def start_game
      enter_name
      enter_level
      @game.new_game
      round_game
    end

    def round_game
      loop do
        return loose if @game.attempts.zero?

        message(:question_num, attempts: @game.attempts, hints: @game.hints)
        user_answer = read_from_console
        hint_show if user_answer == HINT
        next message(:invalid_number) unless @game.validate_answer(user_answer)

        @game.take_attempts
        @game.set_user_code(user_answer)
        return win if @game.equal_codes?(user_answer)

        puts @game.game_result
      end
    end

    def hint_show
      if @game.hints.zero?
        message(:over_hint)
        round_game
      end
      puts @game.show_hints
      @game.take_hints
      round_game
    end

    def win
      message(:win)
      message(:progress)
      @game.save if read_from_console.eql? YES
      continue_game? ? start_game : exit
    end

    def loose
      message(:lose)
      continue_game? ? start_game : exit
    end

    def continue_game?
      message(:new_game)
      read_from_console.eql? YES
    end

    def stats_show
      data = @stat.stats

      return message(:empty_stat) unless data

      message(:stats)
      message(:col_table)
      data.each_with_index do |val, index|
        print "#{index}\t"
        val.each do |_key, value|
          print "#{value}\t"
        end
        print "\n"
      end
    end

    private

    def check_answer
      case @answer
      when START then start_game
      when RULES then message(:rulegame)
      when STATS then stats_show
      when EXIT then exit
      end
    end

    def message(msg, params = {})
      puts I18n.t(msg, params)
    end

    def read_from_console
      gets.chomp
    end

    def enter_name
      message(:username)
      name = read_from_console
      return enter_name unless @game.enter_name(name)

      message(:hello, name: name)
    end

    def enter_level
      message(:choose_difficulty, difficulties: DIFFICULTIES.join(' '))
      return input_level unless @game.enter_level(read_from_console)
    end
  end
end
