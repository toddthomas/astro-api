require 'rails_helper'

describe 'Constellation' do
  context '::find_by_abbreviation' do
    it 'succeeds for valid abbreviation' do
      orion = Constellation.find_by_abbreviation('Ori')
      expect(orion.name).to eq 'Orion'
      expect(orion.description).to eq 'the Hunter'
    end
  end
end
