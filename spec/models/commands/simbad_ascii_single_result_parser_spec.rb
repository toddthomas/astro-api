require 'rails_helper'

describe 'SimbadAsciiSingleResultParser' do
  context 'parsing' do
    let(:alpha_cygni) { build_stubbed(:alpha_cygni) }

    it 'succeeds with good data' do
      response_body = File.read(File.join(Rails.root, 'spec', 'resources', 'single-result.txt'))

      stars = Commands::SimbadAsciiSingleResultParser.parse(response_body)
      expect(stars).to eq [alpha_cygni]
    end
  end
end
