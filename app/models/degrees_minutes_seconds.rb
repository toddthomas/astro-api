class DegreesMinutesSeconds
  attr_reader :degrees
  attr_reader :minutes
  attr_reader :seconds

  def initialize(degrees:, minutes:, seconds:)
    @degrees = degrees
    @minutes = minutes
    @seconds = seconds
  end

  def self.parse(data)
    result = nil
    fields = data.strip.split(/[\s:]/)
    if fields.count > 1
      degrees = Integer(fields[0], 10)
      minutes = Integer(fields[1], 10)
      seconds = Float(fields[2]) if fields[2]

      result = new(degrees: degrees, minutes: minutes, seconds: seconds)
    elsif fields.count == 1
      result = new_from_real(Float(data))
    end

    raise ArgumentError, "couldn't parse valid degrees, minutes, seconds out of [#{data}]" unless result.valid?

    result
  end

  def self.new_from_real(value)
    degrees = value.truncate
    decimal_minutes = ((value - degrees).abs * 60)
    minutes = decimal_minutes.truncate
    seconds = (decimal_minutes - minutes) * 60

    result = new(degrees: degrees, minutes: minutes, seconds: seconds)
    raise ArgumentError, "couldn't parse valid degrees, minutes, seconds out of [#{value}]" unless result.valid?

    result
  end

  def negative?
    degrees.negative?
  end

  def positive?
    degrees.positive?
  end

  def to_decimal_degrees
    result = degrees.abs + minutes / 60.0 + seconds / 3600.0
    result = -result if negative?

    result
  end

  def ==(other)
    return true if other.equal?(self)
    return false unless other.is_a?(self.class)

    other.degrees == degrees &&
      other.minutes == minutes &&
      other.seconds == seconds
  end

  def valid?
    degrees.integer? &&
      minutes.integer? &&
      seconds.real? &&
      (-90..90).include?(degrees) &&
      (0..60).include?(minutes) &&
      (0..60).include?(seconds)
  end
end
