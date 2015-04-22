require 'csv'

module ReportCard
  class Runner
    include Sidekiq::Worker

    def perform(params)
      report = ReportCard::Report.find(params['report_name']).new(params)
      email_options = params['email_options']

      tempfile = Tempfile.new(['report_card', '.csv'])
      csv = CSV.open(tempfile, 'wb')
      report.to_csv(csv)
      csv.close

      uploader = ReportCard::Uploader.new
      uploader.store!(csv)

      ReportCard::Mailer.report(uploader.url, email_options).deliver
    end
  end
end
