class Star
  attr_accessor :id # Makes this class compatible with `ActiveRecord::Base`. Otherwise unused.
  attr_accessor :identifier
  attr_accessor :coordinates
  attr_accessor :visual_magnitude
  attr_accessor :object_type
  attr_accessor :spectral_type

  def ==(other)
    return true if other.equal?(self)
    return false unless other.is_a?(self.class)

    identifier == other.identifier
  end

  def valid?
    identifier[0] == '*' &&
      coordinates.valid? &&
      visual_magnitude.is_a?(Numeric)
  end
end
