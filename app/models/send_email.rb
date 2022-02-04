class SendEmail
    require 'sendgrid-ruby'
    include SendGrid
  
    def self.test_email
      from = Email.new(email: 'support@calahe.com') # SendGridの管理画面でSenderに登録したアドレス
      to = Email.new(email: 'futebol.de.salao10@gmail.com') # 送信したいアドレス
      subject = 'テストホゲホゲ'
      content = Content.new(type: 'text/plain', value: 'ハローハロー')
      mail = Mail.new(from, subject, to, content)
  
      sg = SendGrid::API.new(api_key: ENV['SENDGRID_API_KEY'])
      response = sg.client.mail._('send').post(request_body: mail.to_json)
    end
  end
