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

  def self.find_by_abbreviation(abbreviation)
    all.select { |constellation| constellation.abbreviation == abbreviation }.first
  end
end
