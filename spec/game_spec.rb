# spec/game_spec.rb

RSpec.describe Game do
  subject { Game.new }

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

  context '#valid_answer' do
    it 'it not digits' do
      expect(subject.validate_answer('test')).to be_falsey
    end

    it 'it four digits' do
      expect(subject.validate_answer('1234')).to be_truthy
    end

    it 'it six digits' do
      expect(subject.validate_answer('123456')).to be_falsey
    end
  end

  context '#valid_name' do
    it 'short name' do
      expect(subject.validate_name('t')).to be_falsey
    end

    it 'normal name' do
      expect(subject.validate_name('test')).to be_truthy
    end

    it 'long name' do
      expect(subject.validate_name('testtesttesttesttesttesttesttesttest')).to be_falsey
    end
  end

  context '#validate_level' do
    it 'easy level' do
      expect(subject.validate_level('easy')).to be_truthy
    end

    it 'medium level' do
      expect(subject.validate_level('medium')).to be_truthy
    end

    it 'hard level' do
      expect(subject.validate_level('hard')).to be_truthy
    end

    it 'wrong level' do
      expect(subject.validate_name('testtesttesttesttesttesttesttesttest')).to be_falsey
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

  context 'enter code' do
    it 'test wrong enter code' do
      subject.instance_variable_set(:@secret_code, [1, 4, 1, 1])
      expect(subject.code?('3333')).to be_falsey
    end
    it 'test wrong enter code' do
      subject.instance_variable_set(:@secret_code, [1, 4, 1, 1])
      expect(subject.code?('1411')).to be_truthy
    end
  end

  context 'assigns round_result to' do
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

  describe '#input_code' do
    it 'take a guess and inputs code' do
      subject.instance_variable_set(:@user_code, [1, 2, 3, 6])
      expect(subject.user_code).not_to be_empty
    end
  end
end
