$:.push File.expand_path('../lib', __FILE__)

# Maintain your gem's version:
require 'report_card/version'

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = 'report_card'
  s.version     = ReportCard::VERSION
  s.authors     = ['Nick Giancola']
  s.email       = ['nick@gophilosophie.com']
  s.homepage    = 'http://github.com/patbenatar/report_card'
  s.summary     = 'Write your domain-specific reporting code and let Report Card take care of the rest.'
  s.description = 'Report Card mounts in your Rails app to allow your user to generate CSVs from a list of available reports. CSVs are generated in the background, uploaded to your store via CarrierWave, and emailed to the requester when ready.'
  s.license     = 'MIT'

  s.files = Dir['{app,config,db,lib}/**/*', 'MIT-LICENSE', 'Rakefile', 'README.rdoc']
  s.test_files = Dir['test/**/*']

  s.add_dependency 'rails', '>= 4.0'
  s.add_dependency 'carrierwave', '>= 0.9'
  s.add_dependency 'sidekiq', '>= 2.17'
  s.add_dependency 'active_attr', '>= 0.8.4'

  s.add_development_dependency 'sqlite3'
end
