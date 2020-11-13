require 'rails_helper'

describe 'Constellations', type: :request do
  let(:headers) { {'Accept' => 'application/json'} }

  context 'GET /constellations' do
    it 'returns http success' do
      get '/constellations', headers: headers
      expect(response).to have_http_status(:success)
    end
  end

  context 'GET /constellations/:id' do
    it 'returns http success for valid constellation identifier' do
      get '/constellations/orion', headers: headers
      expect(response).to have_http_status(:success)
      expect(response.body).to match /Orion/
    end

    it 'returns not found for invalid constellation identifier' do
      get '/constellations/not-a-constellation', headers: headers
      expect(response).to have_http_status(:not_found)
    end
  end

  context 'GET /constellations/:id/stars' do
    it 'returns http success for valid constellation and query params' do
      get '/constellations/crux/stars', params: {limiting_magnitude: 3}, headers: headers
      expect(response).to have_http_status(:success)
      response_object = JSON.parse(response.body)
      expect(response_object.dig('search', 'result_count')).to eq 5
    end
  end

end
