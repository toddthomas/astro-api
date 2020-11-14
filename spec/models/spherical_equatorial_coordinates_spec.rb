require 'rails_helper'

describe SphericalEquatorialCoordinates do
  let(:coords_with_positive_dec) do
    SphericalEquatorialCoordinates.new(
      right_ascension: HoursMinutesSeconds.parse('20 41 25.91514'),
      declination: DegreesMinutesSeconds.parse('+45 16 49.2197')
    )
  end

  let(:coords_with_neg_dec) do
    SphericalEquatorialCoordinates.new(
      right_ascension: HoursMinutesSeconds.parse('13 25 11.57937'),
      declination: DegreesMinutesSeconds.parse('-11 09 40.7501')
    )
  end

  let(:coords_with_pos_zero_deg_dec) do
    SphericalEquatorialCoordinates.new(
      right_ascension: HoursMinutesSeconds.parse('13 25 11.57937'),
      declination: DegreesMinutesSeconds.parse('00 09 40.7501')
    )
  end

  let(:coords_with_neg_zero_deg_dec) do
    SphericalEquatorialCoordinates.new(
      right_ascension: HoursMinutesSeconds.parse('13 25 11.57937'),
      declination: DegreesMinutesSeconds.parse('-00 49 40.7501')
    )
  end

  context '::parse' do

    it 'succeeds with good data' do
      expect(SphericalEquatorialCoordinates.parse('20 41 25.91514 +45 16 49.2197')).to eq coords_with_positive_dec
    end
  end

  context '#to_s' do
    it 'is correct for positive dec' do
      expect(coords_with_positive_dec.to_s).to eq 'RA 20h 41m 25.91514s Dec +45° 16\' 49.2197"'
    end

    it 'is correct for negative dec' do
      expect(coords_with_neg_dec.to_s).to eq 'RA 13h 25m 11.57937s Dec -11° 9\' 40.7501"'
    end

    it 'is correct for positive 0 degrees dec' do
      expect(coords_with_pos_zero_deg_dec.to_s).to eq 'RA 13h 25m 11.57937s Dec +0° 9\' 40.7501"'
    end

    it 'is correct for positive 0 degrees dec' do
      expect(coords_with_neg_zero_deg_dec.to_s).to eq 'RA 13h 25m 11.57937s Dec -0° 49\' 40.7501"'
    end
  end
end
