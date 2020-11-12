class SphericalEquatorialCoordinates
  attr_accessor :right_ascension
  attr_accessor :declination

  def initialize(right_ascension:, declination:)
    @right_ascension = right_ascension
    @declination = declination
  end

  def ==(other)
    return true if other.equal? self
    return false unless other.is_a? self.class

    other.right_ascension == right_ascension &&
      other.declination == declination
  end
end
