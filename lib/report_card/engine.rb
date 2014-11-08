module ReportCard
  class Engine < ::Rails::Engine
    initializer 'report_card.load_reports_in_development' do |app|
      if Rails.env.development?
        reports = Dir[Rails.root.join('app/reports/**/*.rb')]
        config.eager_load_paths += reports
        ActionDispatch::Reloader.to_prepare do
          reports.each { |f| require_dependency f }
        end
      end
    end
  end
end
