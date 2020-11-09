require 'rails_helper'

describe Commands::SimbadRaDecParser do
  context 'parsing right ascension' do
    it 'succeeds' do
      expect(Commands::SimbadRaDecParser.parse_ra(from: '03 08 10.1324535 +40 57 20.328013')).to eq 3.13614790375
    end
  end

  context 'declination is positive' do
    it 'succeeds' do
      expect(Commands::SimbadRaDecParser.parse_dec(from: '03 08 10.1324535 +40 57 20.328013')).to eq 40.95564667027778
    end
  end

  context 'declination is negative' do
    it 'succeeds' do
      expect(Commands::SimbadRaDecParser.parse_dec(from: '05 36 12.81335 -01 12 06.9089')).to eq -1.2019191388888888
    end
  end
end
