# spec/validation_spec.rb

RSpec.describe Codebreaker::Game do
  subject { Codebreaker::Game.new }

  context '#valid_answer' do
    it 'it not digits' do
      expect(subject.validate_code('test')).to be_falsey
    end

    it 'it four digits' do
      expect(subject.validate_code('1234')).to be_truthy
    end

    it 'it six digits' do
      expect(subject.validate_code('123456')).to be_falsey
    end
  end

  context '#valid_length' do
    it 'short name' do
      expect(subject.validate_length('t')).to be_falsey
    end

    it 'normal length' do
      expect(subject.validate_length('test')).to be_truthy
    end

    it 'long length' do
      expect(subject.validate_length('testtesttesttesttesttesttesttesttest')).to be_falsey
    end
  end
end
