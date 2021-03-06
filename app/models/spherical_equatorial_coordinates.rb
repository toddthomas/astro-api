class SphericalEquatorialCoordinates
  attr_accessor :right_ascension
  attr_accessor :declination

  def initialize(right_ascension:, declination:)
    @right_ascension = right_ascension
    @declination = declination
  end

  def self.parse(data)
    parse_error_message = "couldn't parse RA and DEC from [#{data}]"
    match = data.match(/(\d+ \d+ \d+\.*\d+)\s+([+-]\d+ \d+ \d+\.*\d+)/)
    raise ArgumentError, parse_error_message if match.nil?

    ra_data, dec_data = match.captures

    result = new(
      right_ascension: HoursMinutesSeconds.parse(ra_data),
      declination: DegreesMinutesSeconds.parse(dec_data)
    )
    raise ArgumentError, parse_error_message unless result.valid?

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

  def to_s
    "RA #{right_ascension.to_s} Dec #{declination.to_s}"
  end

  def to_rounded_string
    "#{right_ascension.to_rounded_string} #{declination.to_decimal_degrees_string}"
  end
end
