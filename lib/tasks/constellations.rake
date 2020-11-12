require 'nokogiri'
require 'open-uri'

namespace :constellations do
  desc "Generate marshalled `Constellation` list from the IAU website"
  task generate_yaml: :environment do
    constellations = []
    doc = Nokogiri::HTML(URI.open('https://www.iau.org/public/themes/constellations/'))

    doc.css('tr').each_with_index do |row, index|
      next if index == 0

      data = row.css('td')
      name = data[0].children.select { |kid| kid.content.strip.present? }.first.content
      puts "Processing #{name}..."
      abbreviation = data[1].content
      description = data[2].content
      genitive = data[3].children.select { |kid| kid.content.strip.present? }.first.content
      boundary_vertices_path = data[4].css('p')[1].css('a').first['href']
      boundary_vertices_url = "https://www.iau.org#{boundary_vertices_path}"
      response = HTTParty.get(boundary_vertices_url)
      puts "got #{response.code} from #{boundary_vertices_url}"
      boundary_vertices = []
      response.each_line do |line|
        fields = line.split('|')
        if fields.count < 2
          warn "bad coordinates for line [#{line}]"
          next
        end
        ra = HoursMinutesSeconds.parse(fields[0])
        dec = DegreesMinutesSeconds.parse(fields[1])
        boundary_vertices << SphericalEquatorialCoordinates.new(right_ascension: ra, declination: dec)
      end

      constellations << Constellation.new(
        name: name.strip,
        abbreviation: abbreviation.strip,
        description: description.strip,
        genitive: genitive.strip,
        boundary_vertices: boundary_vertices
      )
      puts 'done.'
    end

    File.write('constellations.yml', constellations.to_yaml)
  end

end
