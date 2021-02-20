class ContactForm < MailForm::Base
  attributes :name,  :validate => true
  attributes :email, :validate => /\A([\w\.%\+\-]+)@([\w\-]+\.)+([\w]{2,})\z/i
  attributes :message
  attributes :subject

  def headers
    {
      :subject => subject,
      :to => 'aravindpudayoor@gmail.com',
      :from => %("#{name}" <#{email}>)
    }
  end
end