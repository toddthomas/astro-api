require 'rails_helper'

describe Simbad do
  context 'stars' do
    it 'succeeds with a magnitude constraint' do
      response = subject.stars('Vmag<=1.0')
      expect(response.code).to eq 200
      expect(response.body).to match /Number of objects : 17/
    end
  end
end
