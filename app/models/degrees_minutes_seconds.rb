class DegreesMinutesSeconds
  attr_reader :sign
  attr_reader :degrees
  attr_reader :minutes
  attr_reader :seconds

  def initialize(sign:, degrees:, minutes:, seconds:)
    @sign = sign
    @degrees = degrees
    @minutes = minutes
    @seconds = seconds
  end

  def self.parse(data)
    result = nil
    fields = data.strip.split(/[\s:]/)
    if fields.count > 1
      sign = fields[0][0] == '-' ? :negative : :positive
      degrees = Integer(fields[0], 10).abs
      minutes = Integer(fields[1], 10)
      seconds = Float(fields[2]) if fields[2]

      result = new(sign: sign, degrees: degrees, minutes: minutes, seconds: seconds)
    elsif fields.count == 1
      result = new_from_real(Float(data))
    end

    raise ArgumentError, "couldn't parse valid degrees, minutes, seconds out of [#{data}]" unless result.valid?

    result
  end

  def self.new_from_real(value)
    sign = value.negative? ? :negative : :positive
    degrees = value.truncate.abs
    decimal_minutes = ((value.abs - degrees) * 60)
    minutes = decimal_minutes.truncate
    seconds = (decimal_minutes - minutes) * 60

    result = new(sign: sign, degrees: degrees, minutes: minutes, seconds: seconds)
    raise ArgumentError, "couldn't parse valid degrees, minutes, seconds out of [#{value}]" unless result.valid?

    result
  end

  def negative?
    sign == :negative
  end

  def positive?
    sign == :positive
  end

  def to_decimal_degrees
    result = degrees.abs + minutes / 60.0 + seconds / 3600.0
    result = -result if negative?

    result
  end

  def to_s
    "#{negative? ? '-' : '+'}#{degrees}° #{minutes}' #{seconds}\""
  end

  def to_decimal_degrees_string
    "#{!negative? ? '+' : ''}#{to_decimal_degrees}"

  end

  def to_rounded_string
    "#{negative? ? '-' : '+'}#{degrees} #{minutes} #{seconds.round(7)}"
  end

  def ==(other)
    return true if other.equal?(self)
    return false unless other.is_a?(self.class)

    other.sign == sign &&
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
