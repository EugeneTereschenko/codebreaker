module Validation
  USER_ANSWER_REX = /^[1-6]{4}$/

  def validate_name(name)
    name.size > 2 && name.size < 21
  end

  def validate_level(level)
    %w[easy medium hard].include? level
  end

  def validate_answer(user_answer)
    user_answer =~ USER_ANSWER_REX
  end
end
