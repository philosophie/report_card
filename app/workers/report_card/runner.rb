require 'csv'

module ReportCard
  class Runner
    include Sidekiq::Worker

    def perform(klass_name, recipient_email)
      report = ReportCard::Report.find(klass_name).new

      tempfile = Tempfile.new('report_card')
      csv = CSV.open(tempfile, 'wb')
      report.to_csv(csv)

      uploader = ReportCard::Uploader.new
      uploader.store!(csv)

      csv.close

      ReportCard::Mailer.report(uploader.url, recipient_email).deliver
    end
  end
end
