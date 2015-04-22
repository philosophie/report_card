module ReportCard
  class Mailer < ActionMailer::Base
    def report(url, email_options)
      @url = url
      @body = email_options['body'] || ReportCard.body
      # email_options['recipient_email'] doesn't have default option here
      # because it is a proc that is evaluated in ReportsController.
      mail to: email_options['recipient_email'],
           from: email_options['from_email'] || ReportCard.from_email,
           subject: email_options['subject'] || ReportCard.subject
    end
  end
end
