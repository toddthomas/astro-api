# SIMBAD's ASCII format for criteria queries looks like
=begin
C.D.S.  -  SIMBAD4 rel 1.7  -  2020.11.09CET06:33:58

Umag <= 2
---------

Number of objects : 65

# |            identifier             |typ|       coord1 (ICRS,J2000/2000)        |Mag U |Mag B |Mag V |Mag R |Mag I |  spec. type   |#bib|#not
--|-----------------------------------|---|---------------------------------------|------|------|------|------|------|---------------|----|----
1 |* bet Per                          |Al*|03 08 10.1324535 +40 57 20.328013      | 1.70 | 2.07 | 2.12 | 2.08 | 2.11 |B8V            |1153|   2
2 |* alf Cyg                          |sg*|20 41 25.91514 +45 16 49.2197          | 1.11 | 1.34 | 1.25 | 1.14 | 1.04 |A2Ia           | 720|   0
3 |* gam Cas                          |Be*|00 56 42.5317 +60 43 00.265            | 1.18 | 2.29 | 2.39 | 2.32 | 2.40 |B0.5IVpe       |1142|   1
================================================================================
=end
#
# See http://simbad.u-strasbg.fr/simbad/sim-help?Page=sim-url
module Commands::SimbadAsciiParser
  def self.parse(ascii)
    stars = []

    ascii.each_line do |line|
      if line.chomp! =~ /^\d+\s*\|/
        begin
          fields = line.split('|')
          identifier = fields[1].strip

          # For reasons currently unknown, queries for objects of type 'Star' sometimes return objects from the
          # Revised Bologna Catalogue of M31 globular clusters and candidates (http://www.bo.astro.it/M31/)--even when
          # they should be filtered out by magnitude constraints. Exclude them manually here.
          next if identifier.start_with?('Bol ')

          star = Star.new
          star.identifier = identifier
          star.coordinates = SphericalEquatorialCoordinates.parse(fields[3])
          star.visual_magnitude = fields[6].to_f
          star.spectral_type = fields[9].strip

          unless star.valid?
            raise "invalid star #{star.inspect}"
          end

          stars << star

        rescue => e
          raise SimbadParserError, "error [#{e.message}] parsing line [#{line}]"
        end
      end
    end

    stars
  end
end
