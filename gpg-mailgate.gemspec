lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |gem|
  gem.name          = 'gpg-mailgate'
  gem.version       = '0.0.1'
  gem.authors       = ['Igor Rzegocki']
  gem.email         = ['ajgon@irgon.com']
  gem.description   = 'GPG Mail Gateway for Postfix'
  gem.summary       = 'GPG Mail Gateway for Postfix'
  gem.homepage      = 'https://github.com/ajgon/gpg-mailgate'

  gem.files         = `git ls-files`.split("\n")
  gem.executables   = gem.files.grep(/^bin\//).map { |f| File.basename(f) }
  gem.test_files    = gem.files.grep(/^(test|spec|features)\//)
  gem.require_paths = ['lib']

  gem.add_dependency('mail')
end
