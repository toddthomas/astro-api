require 'rails_helper'

RSpec.describe 'Stars', type: :request do
  let(:headers) { {Accept: 'application/json'} }

  context 'GET /stars' do
    it 'returns http success for valid query params' do
      get '/stars', params: {limiting_magnitude: 1}, headers: headers
      expect(response).to have_http_status(:success)
      response_object = JSON.parse(response.body)
      expect(response_object.dig('search', 'result_count')).to eq 17
    end

    it 'returns http bad request for invalid query params' do
      get '/stars', params: {limiting_magnitude: 'shazbot'}, headers: headers
      expect(response).to have_http_status(:bad_request)
      expect(response.body).to match /is not a number/
    end
  end
end
