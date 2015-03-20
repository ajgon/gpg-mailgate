require 'json'
require 'yaml'

module GpgMailgate
  # Storage for all configuration parameters
  # rubocop:disable Style/ModuleFunction
  module Config
    extend self
    attr_reader :config
    alias_method :to_hash, :config

    CONFIG_FILE = '/etc/gpg-mailgate.yml'

    @config = {}

    def load(path = CONFIG_FILE)
      @config = File.exist?(path) ? YAML.load_file(path) : {}
      self
    end

    def method_missing(name, value = nil)
      name = name.to_s.sub(/=$/, '')
      @config[name] = value if value
      @config[name]
    end
  end
  # rubocop:enable Style/ModuleFunction
end
