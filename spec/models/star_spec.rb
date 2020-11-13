require 'rails_helper'

describe Star do
  let(:deneb1) { build_stubbed(:alpha_cygni) }
  let(:deneb2) { build_stubbed(:alpha_cygni) }
  let(:betelgeuse) { build_stubbed(:betelgeuse) }

  context 'equality check' do
    it 'is true when different instances are logically equal' do
      expect(deneb1 == deneb2).to eq true
    end

    it "is false when different instances aren't logically equal" do
      expect(deneb1 == betelgeuse).to eq false
    end

    it 'is true when comparing same instance' do
      expect(deneb2 == deneb2).to eq true
    end
  end

  context 'validity check' do
    let(:bad_identifier) do
      betelgeuse.clone.tap do |bad|
        bad.identifier = ''
      end
    end

    let(:bad_ra) do
      betelgeuse.tap do |bad|
        bad.coordinates.right_ascension = HoursMinutesSeconds.new(
          hours: 25,
          minutes: 73,
          seconds: 900.2
        )
      end
    end

    let(:bad_dec) do
      betelgeuse.tap do |bad|
        bad.coordinates.declination = DegreesMinutesSeconds.new(
          sign: :negative,
          degrees: 152,
          minutes: 700,
          seconds: 452.3
        )
      end
    end

    let(:bad_mag) do
      betelgeuse.tap do |bad|
        bad.visual_magnitude = '0.42'
      end
    end

    it 'is true for valid instances' do
      expect(deneb1.valid?).to eq true
      expect(betelgeuse.valid?).to eq true
    end

    it 'is false for invalid identifier' do
      expect(bad_identifier.valid?).to eq false
    end

    it 'is false for invalid RA' do
      expect(bad_ra.valid?).to eq false
    end

    it 'is false for invalid DEC' do
      expect(bad_dec.valid?).to eq false
    end

    it 'is false for invalid magnitude' do
      expect(bad_mag.valid?).to eq false
    end
  end
end
