# Basic methods used by application call
module GpgMailgate
  def self.encrypt(message)
    config_keys = Config.keys

    mail = Mail.new(message) do
      gpg keys: config_keys
    end
    Mail::Gpg.encrypt(mail, keys: config_keys, recipients: config_keys.keys).to_s
  end
end
