class SphericalEquatorialCoordinates
  attr_accessor :right_ascension
  attr_accessor :declination

  def initialize(right_ascension:, declination:)
    @right_ascension = right_ascension
    @declination = declination
  end

  def self.parse(data)
    ra_data = data.match(/^(\d+ \d+ \d+\.\d+)/).captures.first
    dec_data = data.match(/([+-]\d+ \d+ \d+\.\d+)/).captures.first

    result = new(
      right_ascension: HoursMinutesSeconds.parse(ra_data),
      declination: DegreesMinutesSeconds.parse(dec_data)
    )
    raise ArgumentError, "couldn't parse RA and DEC from [#{data}]" unless result.valid?

    result
  end

  def ==(other)
    return true if other.equal? self
    return false unless other.is_a? self.class

    other.right_ascension == right_ascension &&
      other.declination == declination
  end

  def valid?
    right_ascension.valid? &&
      declination.valid?
  end
end
