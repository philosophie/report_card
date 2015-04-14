module ReportCard
  class ReportsController < ReportCardController
    def index
      @reports = ReportCard::Report.all
    end

    def create
      if ReportCard::Report.exists?(params[:report_name])
        email = instance_eval(&ReportCard.recipient_email)
        ReportCard::Runner.perform_async(params, email)
        redirect_to report_card_reports_path, flash: { success: 'Generating report. It will be emailed to you.' }
      else
        redirect_to report_card_reports_path, flash: { error: 'Could not find report' }
      end
    end
  end
end
