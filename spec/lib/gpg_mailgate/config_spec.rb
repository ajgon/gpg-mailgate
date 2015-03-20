require 'spec_helper'

RSpec.describe GpgMailgate::Config do
  context 'no config file' do
    let(:config) { GpgMailgate::Config.load(File.join(RSpec.configuration.fixture_path, 'no-name')) }

    it 'should return empty object' do
      expect(config.to_hash).to eq({})
    end
  end

  context 'config file' do
    let(:config) { GpgMailgate::Config.load(File.join(RSpec.configuration.fixture_path, 'gpg-mailgate.yml')) }

    it 'should return configuration' do
      expect(config.keys['test-key@example.com']).to match(/BEGIN PGP PUBLIC KEY BLOCK/)
    end
  end
end
