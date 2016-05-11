class Report < MailForm::Base
  attribute :name,      :validate => true
  attribute :email,     :validate => /\A([\w\.%\+\-]+)@([\w\-]+\.)+([\w]{2,})\z/i
  attribute :id,        :validate => true
  attribute :title,     :validate => true
  attribute :message

  # Declare the e-mail headers. It accepts anything the mail method
  # in ActionMailer accepts.
  def headers
    {
        :subject => "Reported Content",
        :to => "villagememoriesbcm2015@gmail.com",
        :from => %("#{name}" <#{email}>)
    }
  end
end
