require 'digest'

def encrypted_mail(message)
  encrypted_message = GpgMailgate.encrypt(message)
  Mail.new(encrypted_message)
end

def fixture_path(file)
  File.join(RSpec.configuration.fixture_path, file)
end

def md5(item)
  Digest::MD5.hexdigest(item)
end
