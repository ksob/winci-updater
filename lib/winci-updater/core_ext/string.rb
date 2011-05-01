class String
  def match_any?(arrayOfPatterns)
    arrayOfPatterns.each do |pattern|
      result = self.match(/#{pattern}/m)
      return true if result
    end
    return false
  end
end