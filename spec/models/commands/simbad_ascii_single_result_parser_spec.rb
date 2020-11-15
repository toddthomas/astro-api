require 'rails_helper'

describe 'SimbadAsciiSingleResultParser' do
  context 'parsing' do
    let(:alpha_cygni) { build_stubbed(:alpha_cygni) }

    it 'succeeds with good data' do
      response_body = File.read(File.join(Rails.root, 'spec', 'resources', 'single-result.txt'))

      stars = Commands::SimbadAsciiSingleResultParser.parse(response_body)
      expect(stars).to eq alpha_cygni
    end

    it 'raises `NotFoundError` for invalid ID' do
      response_body = File.read(File.join(Rails.root, 'spec', 'resources', 'single-result-not-found.txt'))

      expect do
        Commands::SimbadAsciiSingleResultParser.parse(response_body)
        end.to raise_error NotFoundError, /can't find star identified by 'beeblebrox'/
    end
  end
end
