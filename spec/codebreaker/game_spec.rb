# spec/game_spec.rb

RSpec.describe Codebreaker::Game do
  context 'secret_code' do
    let(:secret_code) { subject.secret_code }

    it 'returns secret code' do
      subject.new_game
      expect(subject.secret_code).to be_kind_of(Array)
    end

    it 'has 4 digit' do
      subject.new_game
      expect(subject.secret_code.size).to eq(4)
    end

    it 'has only digits between 1 and 6' do
      subject.new_game
      expect(subject.secret_code.join).to match(/^[1-6]{4}$/)
    end

    it 'user_code is empty' do
      subject.new_game
      expect(subject.user_code).to be_nil
    end
  end

  context '#enter_level' do
    it 'test hard' do
      subject.enter_level('hard')
      expect(subject.attempts).to eq(10)
      expect(subject.hints).to eq(1)
    end

    it 'test medium' do
      subject.enter_level('medium')
      expect(subject.attempts).to eq(15)
      expect(subject.hints).to eq(2)
    end

    it 'test easy' do
      subject.enter_level('easy')
      expect(subject.attempts).to eq(30)
      expect(subject.hints).to eq(3)
    end
  end

  context 'enter_name' do
    it 'enter valid name' do
      subject.enter_name('asdasdasdasd')
      expect(subject.name).not_to be_empty
      expect(subject.name).to eq('asdasdasdasd')
    end

    it 'enter not valid name' do
      subject.enter_name('')
      expect(subject.name).to be_nil
    end
  end

  context 'enter code' do
    it 'test wrong enter code' do
      subject.instance_variable_set(:@secret_code, [1, 4, 1, 1])
      expect(subject.equal_codes?('3333')).to eq(false)
    end
    it 'test wrong enter code' do
      subject.instance_variable_set(:@secret_code, [1, 4, 1, 1])
      expect(subject.equal_codes?('1411')).to eq(true)
    end
  end

  context 'take attempts' do
    it 'test take attempts' do
      subject.instance_variable_set(:@attempts, 5)
      expect { subject.take_attempts }.to change { subject.attempts }.from(5).to(4)
    end
  end

  context 'take_hints' do
    it 'take hints' do
      subject.instance_variable_set(:@hints, 5)
      subject.take_hints
      expect(subject.hints).to eq(4)
    end
  end

  context 'show_hints' do
    it 'show hints' do
      subject.instance_variable_set(:@secret_code, [0, 1, 2, 3])
      subject.instance_variable_set(:@hints_index, [0, 1])
      expect(subject.show_hints).to eq(0)
    end
  end

  context 'set_user_code' do
    it 'set user code' do
      subject.instance_variable_set(:@user_code, [0, 1, 2, 3])
      expect(subject.set_user_code('0123')).to be_truthy
    end
  end

  context 'handle_guess' do
    it 'handle guess' do
      subject.instance_variable_set(:@attempts, 5)
      subject.handle_guess('')
      expect(subject.attempts).to be 4
    end
  end

  context 'assigns count_plus to' do
    it '++' do
      subject.instance_variable_set(:@user_code, [6, 5, 4, 3])
      secret_code = [5, 6, 4, 3]
      expect(subject.send(:count_plus, secret_code)).to eq('++')
    end

    it '+' do
      subject.instance_variable_set(:@user_code, [1, 2, 3, 4])
      secret_code = [3, 1, 2, 4]
      expect(subject.send(:count_plus, secret_code)).to eq('+')
    end

    it '++' do
      subject.instance_variable_set(:@user_code, [1, 2, 3, 4])
      secret_code = [1, 5, 2, 4]
      expect(subject.send(:count_plus, secret_code)).to eq('++')
    end

    it '++++' do
      subject.instance_variable_set(:@user_code, [1, 2, 3, 4])
      secret_code = [1, 2, 3, 4]
      expect(subject.send(:count_plus, secret_code)).to eq('++++')
    end
  end

  context 'assigns count_minus to' do
    it '--' do
      subject.instance_variable_set(:@user_code, [6, 5, 1, 2])
      secret_code = [5, 6, 4, 3]
      expect(subject.send(:count_minus, secret_code)).to eq('--')
    end

    it '-' do
      subject.instance_variable_set(:@user_code, [2, 5, 4, 3])
      secret_code = [6, 4, 1, 1]
      expect(subject.send(:count_minus, secret_code)).to eq('-')
    end

    it '----' do
      subject.instance_variable_set(:@user_code, [6, 5, 4, 3])
      secret_code = [3, 4, 5, 6]
      expect(subject.send(:count_minus, secret_code)).to eq('----')
    end

    it '---' do
      subject.instance_variable_set(:@user_code, [1, 2, 3, 5])
      secret_code = [3, 1, 2, 4]
      expect(subject.send(:count_minus, secret_code)).to eq('---')
    end
  end

  context 'assigns round_result to' do
    it '++--' do
      subject.instance_variable_set(:@user_code, [6, 5, 4, 3])
      subject.instance_variable_set(:@secret_code, [5, 6, 4, 3])
      expect(subject.game_result).to eq('++--')
    end

    it '+-' do
      subject.instance_variable_set(:@user_code, [6, 5, 4, 3])
      subject.instance_variable_set(:@secret_code, [6, 4, 1, 1])
      expect(subject.game_result).to eq('+-')
    end

    it '+++' do
      subject.instance_variable_set(:@user_code, [6, 5, 4, 3])
      subject.instance_variable_set(:@secret_code, [6, 5, 4, 4])
      expect(subject.game_result).to eq('+++')
    end

    it '----' do
      subject.instance_variable_set(:@user_code, [6, 5, 4, 3])
      subject.instance_variable_set(:@secret_code, [3, 4, 5, 6])
      expect(subject.game_result).to eq('----')
    end

    it '+' do
      subject.instance_variable_set(:@user_code, [6, 5, 4, 3])
      subject.instance_variable_set(:@secret_code, [6, 6, 6, 6])
      expect(subject.game_result).to eq('+')
    end

    it '-' do
      subject.instance_variable_set(:@user_code, [6, 5, 4, 3])
      subject.instance_variable_set(:@secret_code, [2, 6, 6, 6])
      expect(subject.game_result).to eq('-')
    end

    it '' do
      subject.instance_variable_set(:@user_code, [6, 5, 4, 3])
      subject.instance_variable_set(:@secret_code, [2, 2, 2, 2])
      expect(subject.game_result).to eq('')
    end

    it '++' do
      subject.instance_variable_set(:@user_code, [6, 6, 6, 6])
      subject.instance_variable_set(:@secret_code, [1, 6, 6, 1])
      expect(subject.game_result).to eq('++')
    end

    it '+---' do
      subject.instance_variable_set(:@user_code, [1, 2, 3, 4])
      subject.instance_variable_set(:@secret_code, [3, 1, 2, 4])
      expect(subject.game_result).to eq('+---')
    end

    it '++-' do
      subject.instance_variable_set(:@user_code, [1, 2, 3, 4])
      subject.instance_variable_set(:@secret_code, [1, 5, 2, 4])
      expect(subject.game_result).to eq('++-')
    end

    it '++++' do
      subject.instance_variable_set(:@user_code, [1, 2, 3, 4])
      subject.instance_variable_set(:@secret_code, [1, 2, 3, 4])
      expect(subject.game_result).to eq('++++')
    end

    it '-' do
      subject.instance_variable_set(:@user_code, [2, 2, 2, 4])
      subject.instance_variable_set(:@secret_code, [1, 4, 1, 1])
      expect(subject.game_result).to eq('-')
    end

    it '--' do
      subject.instance_variable_set(:@user_code, [2, 5, 5, 2])
      subject.instance_variable_set(:@secret_code, [1, 2, 2, 1])
      expect(subject.game_result).to eq('--')
    end

    it '---' do
      subject.instance_variable_set(:@user_code, [4, 1, 3, 2])
      subject.instance_variable_set(:@secret_code, [1, 2, 4, 5])
      expect(subject.game_result).to eq('---')
    end

    it '----' do
      subject.instance_variable_set(:@user_code, [4, 1, 3, 2])
      subject.instance_variable_set(:@secret_code, [1, 2, 4, 3])
      expect(subject.game_result).to eq('----')
    end

    it '+' do
      subject.instance_variable_set(:@user_code, [1, 4, 5, 6])
      subject.instance_variable_set(:@secret_code, [1, 2, 3, 2])
      expect(subject.game_result).to eq('+')
    end

    it '++' do
      subject.instance_variable_set(:@user_code, [1, 2, 3, 6])
      subject.instance_variable_set(:@secret_code, [1, 2, 4, 5])
      expect(subject.game_result).to eq('++')
    end

    it '+++' do
      subject.instance_variable_set(:@user_code, [1, 2, 3, 6])
      subject.instance_variable_set(:@secret_code, [1, 2, 3, 5])
      expect(subject.game_result).to eq('+++')
    end

    it '++++' do
      subject.instance_variable_set(:@user_code, [1, 2, 3, 6])
      subject.instance_variable_set(:@secret_code, [1, 2, 3, 6])
      expect(subject.game_result).to eq('++++')
    end
  end

  context '#input_code' do
    it 'take a guess and inputs code' do
      subject.instance_variable_set(:@user_code, [1, 2, 3, 6])
      expect(subject.user_code).not_to be_empty
    end
  end
end
