# Simbad's coordinates look like
# 03 08 10.1324535 +40 57 20.328013
# a.k.a RA hr min sec DEC deg min sec
module Commands::SimbadRaDecParser
  def self.parse_ra(from:)
    ra_hr, ra_min, ra_sec = from.match(/^(\d+) (\d+) (\d+\.\d+)/).captures

    ra_hr.to_i + ra_min.to_f / 60 + ra_sec.to_f / 3600
  end

  def self.parse_dec(from:)
    sign, dec_deg, dec_min, dec_sec = from.match(/([+-])(\d+) (\d+) (\d+\.\d+)/).captures

    result = dec_deg.to_i + dec_min.to_f / 60 + dec_sec.to_f / 3600
    result = -result if sign == '-'

    result
  end
end
