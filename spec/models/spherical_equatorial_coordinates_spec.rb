require 'rails_helper'

describe SphericalEquatorialCoordinates do
  context '::parse' do
    it 'succeeds with good data' do
      expected_result = SphericalEquatorialCoordinates.new(
        right_ascension: HoursMinutesSeconds.parse('20 41 25.91514'),
        declination: DegreesMinutesSeconds.parse('+45 16 49.2197')
      )
      expect(SphericalEquatorialCoordinates.parse('20 41 25.91514 +45 16 49.2197')).to eq expected_result
    end
  end
end
