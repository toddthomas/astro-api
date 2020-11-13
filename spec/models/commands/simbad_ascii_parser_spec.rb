require 'rails_helper'

describe Commands::SimbadAsciiParser do
  context 'parsing' do
    let(:gamma_cassiopeiae) { build_stubbed(:gamma_cassiopeiae) }
    let(:beta_persei) { build_stubbed(:beta_persei) }
    let(:alpha_cygni) { build_stubbed(:alpha_cygni) }
    let(:alpha_eridani) { build_stubbed(:alpha_eridani) }

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
      end.to raise_error(RuntimeError, /invalid star/)
    end

    it 'skips objects from RBC' do
      rbc_response_body = File.read(File.join(Rails.root, 'spec', 'resources', 'stars-plus-rbc.txt'))
      stars = []

      expect do
        stars = Commands::SimbadAsciiParser.parse(rbc_response_body)
      end.to_not raise_error

      expect(stars.count).to eq 43
      expect(stars).to include beta_persei
      expect(stars).to include alpha_eridani
    end
  end
end
