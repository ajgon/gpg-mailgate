require 'spec_helper'

RSpec.describe GpgMailgate do
  let(:message) do
    "Date: Fri, 20 Mar 2015 21:28:24 +0100\r\n" \
    "From: test-from@example.com\r\n" \
    "To: test-to@example.com\r\n" \
    "Message-ID: <test-123@example>\r\n" \
    "Subject: test message\r\n" \
    "Mime-Version: 1.0\r\n" \
    "Content-Type: text/plain;\r\n charset=UTF-8\r\n" \
    "Content-Transfer-Encoding: 7bit\r\n\r\n" \
    'lorem ipsum dolor sit amet'
  end

  it 'should encrypt given message' do
    encrypted_mail = encrypted_mail(message)

    expect(encrypted_mail.encrypted?).to be_truthy
    expect(encrypted_mail.decrypt(password: '').to_s).to eq message
  end

  it 'should not encrypt encrypted message again' do
    encrypted_message = GpgMailgate.encrypt(message).to_s
    encrypted_again_mail = encrypted_mail(encrypted_message)

    expect(encrypted_again_mail.encrypted?).to be_truthy
    expect(encrypted_again_mail.decrypt(password: '').to_s).to eq message
  end

  context 'Attachments' do
    let(:attachment_message) { File.read(File.join(RSpec.configuration.fixture_path, 'attachments.eml')) }

    it 'should properly encrypt message with multiple attachments' do
      encrypted_message = encrypted_mail(attachment_message).to_s
      decrypted_mail = Mail.new(encrypted_message) { gpg(keys: GpgMailgate::Config.keys) }.decrypt(password: '')

      expect(decrypted_mail.encrypted?).to be_falsey
      expect(decrypted_mail.attachments.size).to eq 3
      expect(decrypted_mail.attachments.first.mime_type).to eq 'image/gif'
      expect(decrypted_mail.attachments.first.filename).to eq 'buttercup.gif'
      expect(md5(decrypted_mail.attachments.first.decoded)).to eq md5(File.read(fixture_path('buttercup.gif')))
      expect(decrypted_mail.attachments[1].mime_type).to eq 'image/png'
      expect(decrypted_mail.attachments[1].filename).to eq 'blossom.png'
      expect(md5(decrypted_mail.attachments[1].decoded)).to eq md5(File.read(fixture_path('blossom.png')))
      expect(decrypted_mail.attachments.last.mime_type).to eq 'image/x-icon'
      expect(decrypted_mail.attachments.last.filename).to eq 'bubbles.ico'
      expect(md5(decrypted_mail.attachments.last.decoded)).to eq md5(File.read(fixture_path('bubbles.ico')))
    end

    it 'should not encrypt encrypted message with attachments again' do
      encrypted_message = GpgMailgate.encrypt(attachment_message).to_s
      encrypted_again_mail = encrypted_mail(encrypted_message)

      expect(encrypted_again_mail.encrypted?).to be_truthy
      expect(encrypted_again_mail.decrypt(password: '').to_s).to eq attachment_message
    end
  end
end
