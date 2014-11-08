module ReportCard
  class Mailer < ActionMailer::Base
    def report(url, email)
      @url = url

      mail to: email,
           from: ReportCard.from_email,
           subject: 'Your report is ready'
    end
  end
end
