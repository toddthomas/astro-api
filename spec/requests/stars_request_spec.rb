require 'rails_helper'

RSpec.describe 'Stars', type: :request do
  let(:headers) { {Accept: 'application/json'} }

  context 'GET /stars' do
    it 'returns http success for valid query params' do
      get '/stars', params: {limiting_magnitude: 1}, headers: headers
      expect(response).to have_http_status :success
      response_object = JSON.parse(response.body)
      expect(response_object.dig('search', 'result_count')).to eq 17
    end

    it 'sorts by identifier by default' do
      get '/stars', params: {limiting_magnitude: 1}, headers: headers
      response_object = JSON.parse(response.body)
      expect(response_object.dig('search', 'results').first.dig('star', 'identifier')).to eq '* alf Aql'
      expect(response_object.dig('search', 'results').last.dig('star', 'identifier')).to eq '2MASS J22472789+5807236'
    end

    it 'sorts by magnitude' do
      get '/stars', params: {limiting_magnitude: 2, sort_by: :visual_magnitude}, headers: headers
      response_object = JSON.parse(response.body)
      expect(response_object.dig('search', 'result_count')).to eq 56
      expect(response_object.dig('search', 'results').first.dig('star', 'visual_magnitude')).to eq(-1.46)
      expect(response_object.dig('search', 'results').last.dig('star', 'visual_magnitude')).to eq 1.98
    end

    it 'works for a limit 1 request' do
      get '/stars', params: {limiting_magnitude: 2, max_results: 1}, headers: headers
      expect(response).to have_http_status :success
      response_object = JSON.parse(response.body)
      expect(response_object.dig('search', 'result_count')).to eq 1
      results = response_object.dig('search', 'results')
      expect(results.first.dig('star', 'identifier')).to eq '* alf Cyg'
      expect(results.first.dig('star', 'object_type')).to eq 'sg*'
    end

    it 'returns http bad request for invalid limiting_magnitude' do
      get '/stars', params: {limiting_magnitude: 'shazbot'}, headers: headers
      expect(response).to have_http_status :bad_request
      expect(response.body).to match /is not a number/
    end

    it 'returns http bad request for invalid sort_by' do
      get '/stars', params: {sort_by: 'coordinates'}, headers: headers
      expect(response).to have_http_status :bad_request
      expect(response.body).to match /can\'t sort by that attribute/
    end
  end

  context 'GET /stars/:id' do
    it 'returns http success and correct star for a valid ID' do
      get '/stars/betelgeuse', headers: headers
      expect(response).to have_http_status :success
      response_object = JSON.parse(response.body)
      expect(response_object.dig('star', 'identifier')).to eq '* alf Ori'
    end

    it 'returns http not found for invalid ID' do
      get '/stars/beeblebrox', headers: headers
      expect(response).to have_http_status :not_found
    end
  end
end
