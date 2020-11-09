class Star
  attr_accessor :id
  attr_accessor :identifier
  attr_accessor :right_ascension
  attr_accessor :declination
  attr_accessor :visual_magnitude
  attr_accessor :spectral_type

  def ==(other)
    return true if other.equal?(self)
    return false unless other.kind_of?(self.class)

    identifier == other.identifier
  end

  def valid?
    identifier[0] == '*'
  end
end
