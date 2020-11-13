require 'rails_helper'

describe Simbad do
  context 'stars' do
    let(:brighter_than_1) do
      build_stubbed(
        :star_search,
        limiting_magnitude: 1.0
      )
    end

    let(:brighter_than_3_in_crux) do
      build_stubbed(
        :star_search,
        limiting_magnitude: 3.0,
        constellation_abbreviation: 'Cru'
      )
    end

    let(:brighter_than_2_in_orion) do
      build_stubbed(
        :star_search,
        limiting_magnitude: 2.0,
        constellation_abbreviation: 'Ori'
      )
    end

    let(:brighter_than_4_in_draco) do
      build_stubbed(
        :star_search,
        limiting_magnitude: 4.0,
        constellation_abbreviation: 'Dra'
      )
    end

    let(:brighter_than_4_in_cetus) do
      build_stubbed(
        :star_search,
        limiting_magnitude: 4.0,
        constellation_abbreviation: 'Cet'
      )
    end

    let(:brighter_than_4_in_volans) do
      build_stubbed(
        :star_search,
        limiting_magnitude: 4.0,
        constellation_abbreviation: 'Vol'
      )
    end

    let(:brighter_than_4_in_reticulum) do
      build_stubbed(
        :star_search,
        limiting_magnitude: 4.0,
        constellation_abbreviation: 'Ret'
      )
    end

    let(:brighter_than_4_in_pyx) do
      build_stubbed(
        :star_search,
        limiting_magnitude: 4.0,
        constellation_abbreviation: 'Pyx'
      )
    end

    let(:brighter_than_4_in_vela) do
      build_stubbed(
        :star_search,
        limiting_magnitude: 4.0,
        constellation_abbreviation: 'Vel'
      )
    end

    it 'succeeds with a magnitude constraint' do
      response = subject.stars(brighter_than_1.simbad_query_params)
      expect(response.code).to eq 200
      expect(response.body).to match /Number of objects : 17/
    end

    it 'succeeds with multiple constraints' do
      response = subject.stars(brighter_than_3_in_crux.simbad_query_params)
      expect(response.code).to eq 200
      expect(response.body).to match /Number of objects : 5/
    end

    it 'succeeds for a constellation with 7 boundary vertices' do
      response = subject.stars(brighter_than_4_in_volans.simbad_query_params)
      expect(response.code).to eq 200
      expect(response.body).to match /Number of objects : 5/
    end

    skip 'currently doesn\'t succeed for a constellation with 8 boundary vertices' do
      response = subject.stars(brighter_than_4_in_pyx.simbad_query_params)
      expect(response.code).to eq 200
      expect(response.body).to match /Number of objects : 42/
    end

    skip 'currently doesn\'t succeed for a constellation with the largest number (50) of boundary vertices' do
      response = subject.stars(brighter_than_4_in_draco.simbad_query_params)
      expect(response.code).to eq 200
      expect(response.body).to match /Number of objects : 42/
    end

    it 'succeeds for Vela, which has 14 vertices 🤷‍♂️' do
      response = subject.stars(brighter_than_4_in_vela.simbad_query_params)
      expect(response.code).to eq 200
      expect(response.body).to match /Number of objects : 2/
    end
  end
end
