module Mail
  module Gpg
    def self.encrypt(cleartext_mail, options = {})
      construct_mail(cleartext_mail, options) do
        receivers = []
        receivers += cleartext_mail.to if cleartext_mail.to
        receivers += cleartext_mail.cc if cleartext_mail.cc
        receivers += cleartext_mail.bcc if cleartext_mail.bcc
        #:nocov:
        if options[:sign_as]
          options[:sign] = true
          options[:signers] = options.delete(:sign_as)
        elsif options[:sign]
          options[:signers] = cleartext_mail.from
        end
        #:nocov:

        options = options.merge({recipients: receivers}) unless options[:recipients]

        add_part VersionPart.new
        add_part EncryptedPart.new(cleartext_mail, options)
        content_type "multipart/encrypted; protocol=\"application/pgp-encrypted\"; boundary=#{boundary}"
        body.preamble = options[:preamble] || "This is an OpenPGP/MIME encrypted message (RFC 2440 and 3156)"
      end
    end
  end
end
