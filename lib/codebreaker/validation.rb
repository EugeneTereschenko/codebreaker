module Validation
  def validate_length(word)
    word.size > 2 && word.size < 21
  end

  def validate_code(code)
    code =~ Codebreaker::Game::USER_ANSWER_REX
  end
end
