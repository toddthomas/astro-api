require 'rails_helper'

describe HoursMinutesSeconds do
  context '#to_decimal_hours' do
    it 'succeeds' do
      expect(HoursMinutesSeconds.new(hours: 6, minutes: 30, seconds: 3.6).to_decimal_hours).to eq 6.501
    end
  end

  context '#to_s' do
    it 'has intended format' do
      expect(HoursMinutesSeconds.new(hours: 14, minutes: 45, seconds: 16.2341).to_s).to eq '14h 45m 16.2341s'
    end
  end

  context '::parse' do
    it 'succeeds with valid data' do
      expected_value = HoursMinutesSeconds.new(hours: 16, minutes: 18, seconds: 2.4563234)
      expect(HoursMinutesSeconds.parse('16 18 2.4563234')).to eq expected_value
    end

    it 'raises on bad data' do
      expect do
        HoursMinutesSeconds.parse('Hello, world!')
      end.to raise_error ArgumentError
    end
  end
end
