require 'rails_helper'

describe Simbad do
  context 'stars' do
    it 'succeeds with a magnitude constraint' do
      response = subject.stars('Vmag<=1.0')
      expect(response.code).to eq 200
      expect(response.body).to match /Number of objects : 17/
    end

    it 'succeeds with multiple constraints' do
      response = subject.stars('Vmag<=2.0', 'rah >= 5.0', 'rah <= 6.0', 'dec >= -10.0', 'dec <= 10.0')
      expect(response.code).to eq 200
      expect(response.body).to match /Number of objects : 6/
    end
  end
end
