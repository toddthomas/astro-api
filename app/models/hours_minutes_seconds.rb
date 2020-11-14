class HoursMinutesSeconds
  attr_reader :hours
  attr_reader :minutes
  attr_reader :seconds

  def initialize(hours:, minutes:, seconds:)
    @hours = hours
    @minutes = minutes
    @seconds = seconds
  end

  def self.parse(data)
    fields = data.strip.split(/[\s:]/)
    hours = Integer(fields[0], 10)
    minutes = Integer(fields[1], 10)
    seconds = Float(fields[2]) if fields[2]

    result = new(hours: hours, minutes: minutes, seconds: seconds)
    raise ArgumentError, "couldn't parse valid hours, minutes, seconds out of [#{data}]" unless result.valid?

    result
  end

  def to_decimal_hours
    hours + minutes / 60.0 + seconds / 3600.0
  end

  def to_s
    "#{hours}h #{minutes}m #{seconds}s"
  end

  def to_rounded_string
    "#{hours} #{minutes} #{seconds.round(4)}"
  end

  def ==(other)
    return true if other.equal?(self)
    return false unless other.is_a?(self.class)

    other.hours == hours &&
      other.minutes == minutes &&
      other.seconds == seconds
  end

  def valid?
    hours.integer? &&
      minutes.integer? &&
      seconds.real? &&
      (0..24).include?(hours) &&
      (0..60).include?(minutes) &&
      (0..60).include?(seconds)
  end
end
