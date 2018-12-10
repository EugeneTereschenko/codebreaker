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
      when 'stats' then stats
      when 'exit' then exit
      end
    end
  end

  private

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
    db = Db.new
    codebreaker_data = db.read_database
    puts @game.game_result
    message(:win)
    message(:progress)
    your_want_save = read_from_console
    if your_want_save.eql? 'yes'
      hash_stat = { name: @game.name, level: @game.levels, level_num: @game.level_num, attempts: @game.attempts, attempts_used: @game.attempts_used, hints: @game.hints, hints_used: @game.hints_used }
      codebreaker_data = [] if codebreaker_data.nil?
      codebreaker_data << hash_stat
      db.write_database(codebreaker_data)
    end
    message(:new_game)
    your_want_new_game = read_from_console
    exit unless your_want_new_game.eql? 'yes'
    if your_want_new_game.eql? 'yes'
      input_level
      @game.new_game 
      round_game
    end
  end

  def loose
    message(:lose)
    message(:code_was)
    @game.secret_code.each do |value|
      print value
    end
    puts
    message(:new_game)
    your_want_new_game = read_from_console
    exit unless your_want_new_game.eql? 'yes'
    if your_want_new_game.eql? 'yes'
      input_level
      @game.new_game 
      round_game
    end
  end

  def stats
    db = Db.new
    codebreaker_data = db.read_database
    return message(:empty_stat) unless codebreaker_data
    message(:stats)
    message(:col_table)
    raiting = 0
    codebreaker_data.sort_by! { |stat| [stat[@game.level_num], stat[@game.hints], stat[@game.attempts]] }
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
