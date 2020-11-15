class Star
  attr_accessor :id # Makes this class compatible with `ActiveRecord::Base`. Otherwise unused.
  attr_accessor :identifier
  attr_accessor :coordinates
  attr_accessor :visual_magnitude
  attr_accessor :object_type
  attr_accessor :spectral_type

  def self.simbad_types
    'Star'
  end

  def self.sortable_attributes
    %w(identifier visual_magnitude object_type spectral_type)
  end

  def self.default_sort
    :identifier
  end

  def ==(other)
    return true if other.equal?(self)
    return false unless other.is_a?(self.class)

    identifier == other.identifier &&
      object_type == other.object_type &&
      spectral_type == other.spectral_type
  end

  def valid?
    identifier.present? &&
      coordinates.valid? &&
      visual_magnitude.is_a?(Numeric)
  end
end
