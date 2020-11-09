require 'rails_helper'

describe Star do
  context 'equality check' do
    let(:deneb1) { build_stubbed(:alpha_cygni) }
    let(:deneb2) { build_stubbed(:alpha_cygni) }
    let(:betelgeuse) { build_stubbed(:betelgeuse) }

    it 'true when different instances are logically equal' do
      expect(deneb1 == deneb2).to eq true
    end

    it 'false when different instances aren\'t logically equal' do
      expect(deneb1 == betelgeuse).to eq false
    end

    it 'true when comparing same instance' do
      expect(deneb2 == deneb2).to eq true
    end
  end
end
