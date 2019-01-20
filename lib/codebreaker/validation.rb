module Validation
  def validate_length(word, range)
    range.include?(word.size)
  end

  def validate_code(code, regexp)
    code =~ regexp
  end
end
