class Contact < MailForm::Base
  attribute :name,      :validate => true
  attribute :email,     :validate => /\A([\w\.%\+\-]+)@([\w\-]+\.)+([\w]{2,})\z/i
  attribute :message

  validates_presence_of :name
  validates_presence_of :email
  validates_presence_of :name

  # Declare the e-mail headers. It accepts anything the mail method
  # in ActionMailer accepts.
  def headers
    {
      :subject => "Website Contact",
      :to => "asacook1@sheffield.ac.uk",
      :from => %("#{name}" <#{email}>)
    }
  end
end
