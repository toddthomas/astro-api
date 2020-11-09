require 'rails_helper'

describe Commands::SimbadAsciiParser do
  context 'parsing' do
    let(:gamma_cassiopeiae) { build_stubbed(:gamma_cassiopeiae) }
    let(:beta_persei) { build_stubbed(:beta_persei) }
    let(:alpha_cygni) { build_stubbed(:alpha_cygni) }

    it 'succeeds with good data' do
      response_body = File.read(File.join(Rails.root, 'spec', 'resources', 'three-stars.txt'))

      stars = Commands::SimbadAsciiParser.parse(response_body)
      expect(stars).to include gamma_cassiopeiae
      expect(stars).to include beta_persei
      expect(stars).to include alpha_cygni
    end

    it 'raises on bad data' do
      bad_response_body = File.read(File.join(Rails.root, 'spec', 'resources', 'three-stars-with-errors.txt'))
      expect do
        Commands::SimbadAsciiParser.parse(bad_response_body)
      end.to raise_error(RuntimeError, /couldn't parse star from data \[3 |not a star/)
    end
  end
end
