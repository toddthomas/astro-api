class Constellation
  attr_reader :name
  attr_reader :abbreviation
  attr_reader :genitive
  attr_reader :description
  attr_reader :boundary_vertices

  def initialize(name:, abbreviation:, genitive:, description:, boundary_vertices:)
    @name = name
    @abbreviation = abbreviation
    @genitive = genitive
    @description = description
    @boundary_vertices = boundary_vertices
  end

  def ==(other)
    return true if other.equal?(self)
    return false unless other.is_a?(self.class)

    name == other.name
  end

  def self.all
    @@all ||= YAML.load(File.read('constellations.yml'))
  end

  def self.find(id)
    downcased_id = id.downcase

    result = all.find do |c|
      c.abbreviation.downcase == downcased_id ||
        c.name.downcase == downcased_id
    end
    raise NotFoundError, "no constellation identified by '#{id}'" if result.nil?

    result
  end
end
