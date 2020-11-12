require 'rails_helper'

describe DegreesMinutesSeconds do
  context '#to_decimal_degrees' do
    it 'succeeds' do
      expect(DegreesMinutesSeconds.new(degrees: -90, minutes: 6, seconds: 3.6).to_decimal_degrees).to eq(-90.101)
    end
  end

  context '::new_from_real' do
    it 'succeeds with valid positive real values' do
      expected_value = DegreesMinutesSeconds.new(degrees: 3, minutes: 1, seconds: 52.5)
      expect(DegreesMinutesSeconds.new_from_real(3.03125)).to eq expected_value

      expected_value = DegreesMinutesSeconds.new(degrees: 19, minutes: 0, seconds: 56.25)
      expect(DegreesMinutesSeconds.new_from_real(19.015625)).to eq expected_value
    end

    it 'succeeds with a valid negative real value' do
      expected_value = DegreesMinutesSeconds.new(degrees: -60, minutes: 33, seconds: 45)
      expect(DegreesMinutesSeconds.new_from_real(-60.5625)).to eq expected_value
    end

    it 'succeeds with a zero value' do
      expected_value = DegreesMinutesSeconds.new(degrees: 0, minutes: 0, seconds: 0.0)
      expect(DegreesMinutesSeconds.new_from_real(0.0)).to eq expected_value
    end

    it 'succeeds with a positive integer' do
      expected_value = DegreesMinutesSeconds.new(degrees: 42, minutes: 0, seconds: 0)
      expect(DegreesMinutesSeconds.new_from_real(42)).to eq expected_value
    end

    it 'succeeds with a negative integer' do
      expected_value = DegreesMinutesSeconds.new(degrees: -4, minutes: 0, seconds: 0)
      expect(DegreesMinutesSeconds.new_from_real(-4)).to eq expected_value
    end
  end

  context '::parse' do
    it 'succeeds with valid DMS data' do
      expected_value = DegreesMinutesSeconds.new(degrees: -34, minutes: 18, seconds: 2.4563234)
      expect(DegreesMinutesSeconds.parse('-34 18 2.4563234')).to eq expected_value
    end

    it 'succeeds with valid real data' do
      expected_value = DegreesMinutesSeconds.new(degrees: -60, minutes: 33, seconds: 45)
      expect(DegreesMinutesSeconds.parse('-60.5625')).to eq expected_value
    end

    it 'raises on bad data' do
      expect do
        DegreesMinutesSeconds.parse('Hello, world!')
      end.to raise_error ArgumentError
    end
  end
end
