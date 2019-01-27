RSpec.describe Codebreaker::Console do
  let(:game) { Codebreaker::Game.new }

  context 'launch' do
    it 'launch start' do
      allow(subject).to receive_message_chain(:gets, :chomp) { 'start' }
      expect(subject).to receive(:puts).with("Welcome to game Codebreaker\n")
      expect(subject).to receive(:puts).with("Type start for starting new game.\nType rules for showing rules.\nType stats for showing statistics.\nType exit for exit\n")
      expect(subject).to receive(:start_game)
      subject.launch
    end

    it 'launch stats' do
      allow(subject).to receive_message_chain(:gets, :chomp) { 'stats' }
      expect(subject).to receive(:puts).with("Welcome to game Codebreaker\n")
      expect(subject).to receive(:puts).with("Type start for starting new game.\nType rules for showing rules.\nType stats for showing statistics.\nType exit for exit\n")
      expect(subject).to receive(:stats_show)
      subject.launch
    end

    it 'launch rules' do
      allow(subject).to receive_message_chain(:gets, :chomp) { 'rules' }
      expect(subject).to receive(:puts).with("You have to guess 4-digit number where each digit placed between 1 and 6.\nThe code-maker then marks the guess with up to four + and - signs.\nA + indicates an exact match, one of the numbers in the guess is the same.\nA - indicates a number match, one of the numbers in the guess is the same as one of the numbers in the secret code but in a different position.\n")
      expect(subject).to receive(:puts).with("Welcome to game Codebreaker\n")
      expect(subject).to receive(:puts).with("Type start for starting new game.\nType rules for showing rules.\nType stats for showing statistics.\nType exit for exit\n")
      subject.launch
    end

    it 'launch exit' do
      allow(subject).to receive_message_chain(:gets, :chomp) { 'exit' }
      expect(subject).to receive(:puts).with("Welcome to game Codebreaker\n")
      expect(subject).to receive(:puts).with("Type start for starting new game.\nType rules for showing rules.\nType stats for showing statistics.\nType exit for exit\n")
      expect(subject).to receive(:exit)
      subject.launch
    end
  end

  context 'start game' do
    it 'start_game' do
      expect(subject).to receive(:enter_name)
      expect(subject).to receive(:read_from_console) { 'easy' }
      expect(subject).to receive(:round_game)
      subject.send(:start_game)
    end
  end

  context 'win' do
    it 'win' do
      expect(subject).to receive(:puts).with('your win')
      expect(subject).to receive(:puts).with('Enter yes if you want to save your progress')
      expect(subject).to receive(:puts).with('Enter yes if you want a new game')
      allow(subject).to receive_message_chain(:read_from_console) { :no }
      expect(subject).to receive(:exit)
      subject.win
    end

    it 'loose' do
      expect(subject).to receive(:puts).with('Your lose')
      expect(subject).to receive(:puts).with('Enter yes if you want a new game')
      allow(subject).to receive_message_chain(:read_from_console) { :no }
      expect(subject).to receive(:exit)
      subject.loose
    end
  end

  context 'continue' do
    it 'continue game' do
      expect(subject).to receive(:puts).with('Enter yes if you want a new game')
      allow(subject).to receive_message_chain(:read_from_console) { :no }
      subject.send(:continue_game?)
    end
  end

  context 'round_game' do
    it 'round_game zero attempts' do
      allow(game).to receive(:attempts) { 0 }
      subject.instance_variable_set(:@game, game)
      expect(subject).to receive(:loose)
      subject.round_game
    end

    it 'round_game win' do
      allow(game).to receive(:attempts) { 3 }
      allow(game).to receive(:validate_code) { true }
      allow(game).to receive(:handle_guess)
      allow(game).to receive(:equal_codes?) { true }
      allow(game).to receive(:game_result)
      subject.instance_variable_set(:@game, game)
      allow(subject).to receive(:message_game_read_console) { '1234' }
      expect(subject).to receive(:win)
      subject.round_game
    end
  end

  context 'message' do
    it 'message' do
      expect(subject).to receive(:puts).with("Welcome to game Codebreaker\n")
      subject.send(:message, :start_game)
    end
  end

  context 'read from console' do
    it 'read from console' do
      expect(subject).to receive_message_chain(:gets, :chomp)
      subject.send(:read_from_console)
    end
  end

  context 'enter name' do
    it 'enter name' do
      expect(subject).to receive(:read_from_console)
      allow(game).to receive(:enter_name) { 0 }
      subject.instance_variable_set(:@game, game)
      subject.send(:enter_name)
    end
  end

  context 'message_game_read_console' do
    it 'message_game_read_console' do
      expect(subject).to receive(:read_from_console)
      allow(game).to receive(:attempts) { 0 }
      allow(game).to receive(:hints) { 0 }
      subject.instance_variable_set(:@game, game)
      subject.send(:message_game_read_console)
    end
  end
end
