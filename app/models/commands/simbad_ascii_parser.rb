module Commands::SimbadAsciiParser
  def self.parse(ascii)
    stars = []

    ascii.each_line do |line|
      if line =~ /^\d+/
        fields = line.split('|')

        star = Star.new
        star.identifier = fields[1].strip
        star.right_ascension = Commands::SimbadRaDecParser.parse_ra(from: fields[3])
        star.declination = Commands::SimbadRaDecParser.parse_dec(from: fields[3])
        star.visual_magnitude = fields[6].to_f
        star.spectral_type = fields[9].strip

        unless star.valid?
          raise "couldn't parse star from data [#{line}]"
        end

        stars << star
      end
    end

    stars
  end
end
