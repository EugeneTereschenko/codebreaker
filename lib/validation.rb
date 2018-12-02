module Validation
  def validate_name(name)
    name.size > 2 && name.size < 21
  end

  def validate_level(level)
    %w[easy medium hard].include? level
  end

  def validate_answer(user_answer)
    user_answer =~ /^[1-6]{4}$/
  end
end
