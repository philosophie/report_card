require "report_card/engine"

module ReportCard
  autoload :Report, 'report_card/report'

  mattr_accessor :parent_controller
  self.parent_controller = 'ApplicationController'

  mattr_accessor :recipient_email
  self.recipient_email = -> { 'change-me@example.com' }
end
