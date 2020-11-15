# SIMBAD's ASCII format for criteria queries with a single result looks like
=begin
C.D.S.  -  SIMBAD4 rel 1.7  -  2020.11.15CET02:00:54

otypes='Star' & Vmag <= 2.0
---------------------------

Object * alf Cyg  ---  sg*  ---  OID=@92338   (@@10605,0)  ---  coobox=98

Coordinates(ICRS,ep=J2000,eq=2000): 20 41 25.91514  +45 16 49.2197 (Opt ) A [2.99 2.38 90] 2007A&A...474..653V
Coordinates(FK4,ep=B1950,eq=1950): 20 39 43.53618  +45 06 03.0639
Coordinates(Gal,ep=J2000,eq=2000): 084.28473664  +01.99754611
hierarchy counts: #parents=0, #children=0, #siblings=0
Proper motions: 2.01 1.85 [0.34 0.27 0] A 2007A&A...474..653V
Parallax: 2.31 [0.32] A 2007A&A...474..653V
Radial Velocity: -4.90 [0.3] A 2006AstL...32..759G
Redshift: -0.000016 [0.000001] A 2006AstL...32..759G
cz: -4.90 [0.30] A 2006AstL...32..759G
Flux U : 1.11 [~] C 2002yCat.2237....0D
Flux B : 1.34 [~] C 2002yCat.2237....0D
Flux V : 1.25 [~] C 2002yCat.2237....0D
Flux R : 1.14 [~] C 2002yCat.2237....0D
Flux I : 1.04 [~] C 2002yCat.2237....0D
Flux J : 0.95 [~] C 2002yCat.2237....0D
Flux H : 0.87 [~] C 2002yCat.2237....0D
Flux K : 0.88 [~] C 2002yCat.2237....0D
Spectral type: A2Ia C 1950ApJ...112..362M
Morphological type: ~ ~ ~
Angular size:     ~     ~   ~ (~)  ~ ~
=end
# There's quite a bit more below that, but these first lines are the ones we're currently using. See
# spec/resources/single-result.txt for a full example.
module Commands::SimbadAsciiSingleResultParser
  def self.parse(ascii)
    star = Star.new

    ascii.each_line do |line|
      case line
      when /^!!\s+'(.*)'/
        raise NotFoundError, "can't find star identified by '#{$1}'"
      when /^Object/
        fields = line.split('---')
        star.identifier = fields[0].delete_prefix('Object').strip
        star.object_type = fields[1].strip
      when /^Coordinates\(ICRS,ep=J2000,eq=2000/
        star.coordinates = SphericalEquatorialCoordinates.parse(line)
      when /^Flux V/
        fields = line.split(/\s+/)
        star.visual_magnitude = Float(fields[3])
      when /^Spectral type/
        fields = line.split(/\s+/)
        star.spectral_type = fields[2]
      end
    end

    star
  end
end
