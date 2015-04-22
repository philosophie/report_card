require "report_card/engine"

module ReportCard
  autoload :Report, 'report_card/report'

  mattr_accessor :parent_controller
  self.parent_controller = 'ApplicationController'

  mattr_accessor :recipient_email
  self.recipient_email = -> { 'change-me@example.com' }

  mattr_accessor :from_email
  self.from_email = 'change-me@example.com'

  mattr_accessor :subject
  self.subject = 'Your report is ready'

  mattr_accessor :body
  self.body = 'Download your report: '

  mattr_accessor :flash_success
  self.flash_success = -> { 'Generating report. It will be emailed to you.' }

end
