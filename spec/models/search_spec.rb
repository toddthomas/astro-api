require 'rails_helper'

describe Search, type: :model do
  let(:too_many_results) do
    build_stubbed(
      :star_search,
      max_results: 1000000000
    )
  end

  let(:max_number_of_results) do
    build_stubbed(
      :star_search,
      max_results: 1000
    )
  end

  context 'validations' do
    it 'prevent requesting too many search results' do
      expect(too_many_results).to_not be_valid
    end

    it 'are okay with up to 1000 results' do
      expect(max_number_of_results).to_not be_valid
    end
  end
end
