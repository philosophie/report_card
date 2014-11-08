module ReportCard
  class Mailer < ActionMailer::Base
    def report(url, email)
      @url = url

      mail to: email,
           subject: 'Your report is ready'
    end
  end
end
