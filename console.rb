class Console
  YES = 'yes'.freeze

  def initialize
    @game = Game.new
  end

  def launch
    loop do
      message(:start_game)
      message(:wel_instruct)
      answer = read_from_console
      check_answer(answer)
    end
  end

  def check_answer(answer)
    case answer
    when 'start' then
      enter_name
      enter_level
      @game.new_game
      round_game
    when 'rules' then
      message(:rulegame)
    when 'stats' then stats_show
    when 'exit' then exit
    end
  end

  def round_game
    loose if @game.attempts.zero?
    message(:question_num, attempts: @game.attempts, hints: @game.hints)
    user_answer = read_from_console
    hint_show if user_answer == 'hint'
    message(:invalid_number) unless @game.validate_answer(user_answer)
    @game.take_attempts
    @game.take_user_code(user_answer)
    if @game.test_code(user_answer)
      win
    else
      puts @game.game_result
      round_game
    end
  end

  def hint_show
    if @game.hints.zero?
      message(:over_hint)
      round_game
    end
    @game.secret_code.map.with_index do |element, index|
      print element if index == @game.arr_index[@game.hints - 1]
    end
    print "\n"
    @game.take_hints
    round_game
  end

  def win
    message(:win)
    message(:progress)
    @game.win_save if read_from_console.eql? YES
    restart_game
  end

  def loose
    message(:lose)
    restart_game
  end

  def restart_game
    message(:new_game)
    exit unless read_from_console.eql? YES
    enter_level
    @game.new_game
    round_game
  end

  def stats_show
    data = @game.stats

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
    message(:choose_difficulty)
    return input_level unless @game.enter_level(read_from_console)
  end
end
