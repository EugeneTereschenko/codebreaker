RSpec.describe Codebreaker::Console do
  subject { Codebreaker::Console.new }
  # game_subject { Codebreaker::Game.new }

  HELLO_PHRASES = "Welcome to game Codebreaker\n".freeze

  HELLO_MENU_PHRASES = "Type start for starting new game.\nType rules for showing rules.\nType stats for showing statistics.\nType exit for exit\n".freeze

  RULES = "You have to guess 4-digit number where each digit placed between 1 and 6.\nThe code-maker then marks the guess with up to four + and - signs.\nA + indicates an exact match, one of the numbers in the guess is the same.\nA - indicates a number match, one of the numbers in the guess is the same as one of the numbers in the secret code but in a different position.\n".freeze

  context 'launch' do
    it 'launch start' do
      allow(subject).to receive_message_chain(:gets, :chomp) { 'start' }
      expect(subject).to receive(:puts).with(HELLO_PHRASES)
      expect(subject).to receive(:puts).with(HELLO_MENU_PHRASES)
      expect(subject).to receive(:start_game)
      subject.launch
    end

    it 'launch stats' do
      allow(subject).to receive_message_chain(:gets, :chomp) { 'stats' }
      expect(subject).to receive(:puts).with(HELLO_PHRASES)
      expect(subject).to receive(:puts).with(HELLO_MENU_PHRASES)
      expect(subject).to receive(:stats_show)
      subject.launch
    end

    it 'launch rules' do
      allow(subject).to receive_message_chain(:gets, :chomp) { 'rules' }
      expect(subject).to receive(:puts).with(RULES)
      expect(subject).to receive(:puts).with(HELLO_PHRASES)
      expect(subject).to receive(:puts).with(HELLO_MENU_PHRASES)
      subject.launch
    end

    it 'launch exit' do
      allow(subject).to receive_message_chain(:gets, :chomp) { 'exit' }
      expect(subject).to receive(:puts).with(HELLO_PHRASES)
      expect(subject).to receive(:puts).with(HELLO_MENU_PHRASES)
      expect(subject).to receive(:exit)
      subject.launch
    end
  end

  context 'start game' do
    it 'start_game' do
      expect(subject).to receive(:enter_name)
      expect(subject).to receive(:read_from_console) {'easy'}
      expect(subject).to receive(:round_game)
      subject.start_game
    end
  end
end
