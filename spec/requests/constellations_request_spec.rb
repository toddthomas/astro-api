require 'rails_helper'

describe 'Constellations', type: :request do
  let(:headers) { {'Accept' => 'application/json'} }

  context 'GET /index' do
    it 'returns http success' do
      get '/constellations', headers: headers
      expect(response).to have_http_status(:success)
    end
  end

  context 'GET /show' do
    it 'returns http success for valid constellation identifier' do
      get '/constellations/orion', headers: headers
      expect(response).to have_http_status(:success)
    end

    it 'returns not found for invalid constellation identifier' do
      get '/constellations/not-a-constellation', headers: headers
      expect(response).to have_http_status(:not_found)
    end
  end

end
