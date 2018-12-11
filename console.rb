class Console
  def initialize
    @game = Game.new
  end

  def launch
    loop do
      message(:start_game)
      message(:wel_instruct)
      answer = read_from_console
      case answer
      when 'start' then
        choose_name
        input_level
        @game.new_game
        round_game
      when 'rules' then
        message(:rulegame)
      when 'stats' then stats_show
      when 'exit' then exit
      end
    end
  end

  def round_game
    if @game.attempts.positive?
      puts format(message_return(:question_num), @game.attempts, @game.hints)
      @game.take_attempts
      user_answer = read_from_console
      hint_show if user_answer == 'hint'
      message(:invalid_number) unless @game.validate_answer(user_answer)
      @game.user_code = user_answer.each_char.map(&:to_i)
      if @game.check_code(user_answer)
        win
      else
        puts @game.game_result
        round_game
      end
    else
      loose
    end
  end

  def hint_show
    if @game.hints.zero?
      message(:over_hint)
      round_game
    end
    @game.secret_code.map.with_index do |element, index|
      if index == @game.arr_index[@game.hints - 1]
        print element
      else
        print '*'
      end
    end
    print "\n"
    @game.hints -= 1 if @game.hints > 0
    @game.hints_used += 1 if @game.hints > 0
    round_game
  end

  def win
    puts @game.game_result
    message(:win)
    message(:progress)
    your_want_save = read_from_console
    if your_want_save.eql? 'yes'
      @game.win_save
    end
    restart_game
  end

  def loose
    message(:lose)
    message(:code_was)
    @game.secret_code.each do |value|
      print value
    end
    puts
    restart_game
  end

  def restart_game
    message(:new_game)
    your_want_new_game = read_from_console
    exit unless your_want_new_game.eql? 'yes'
    if your_want_new_game.eql? 'yes'
      input_level
      @game.new_game
      round_game
    end
  end

  def stats_show
    data = @game.stats
    if data.eql?(false)
      message(:empty_stat)
    else
      message(:stats)
      message(:col_table)
      raiting = 0
      data.each do |stat|
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

  private

  def message(msg)
    puts I18n.t msg
  end

  def message_var(msg, var)
    puts I18n.t(msg) + var
  end

  def message_return(msg)
    I18n.t(msg)
  end

  def read_from_console
    gets.chomp
  end

  def choose_name
    message(:username)
    name = read_from_console
    message_var(:hello, name)
    return choose_name unless @game.choose_name(name)
  end

  def input_level
    message(:choose_difficulty)
    return input_level unless @game.choose_level(read_from_console)
  end

end
