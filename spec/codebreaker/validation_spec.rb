# spec/validation_spec.rb

RSpec.describe Validation do
  before(:each) do
    @test_obj = Object.new
    @test_obj.extend(Validation)
  end

  context '#valid_answer' do
    it 'it not digits' do
      expect(@test_obj.validate_code('test', Codebreaker::Game::USER_ANSWER_REX)).to be_falsey
    end

    it 'it four digits' do
      expect(@test_obj.validate_code('1234', Codebreaker::Game::USER_ANSWER_REX)).to be_truthy
    end

    it 'it six digits' do
      expect(@test_obj.validate_code('123456', Codebreaker::Game::USER_ANSWER_REX)).to be_falsey
    end
  end

  context '#valid_length' do
    it 'short name' do
      expect(@test_obj.validate_length('t', Codebreaker::Game::NAME_SIZE_RANGE)).to be_falsey
    end

    it 'normal length' do
      expect(@test_obj.validate_length('test', Codebreaker::Game::NAME_SIZE_RANGE)).to be_truthy
    end

    it 'long length' do
      expect(@test_obj.validate_length('testtesttesttesttesttesttesttesttest', Codebreaker::Game::NAME_SIZE_RANGE)).to be_falsey
    end
  end
end
