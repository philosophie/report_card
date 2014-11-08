# encoding: utf-8

module ReportCard
  class Uploader < CarrierWave::Uploader::Base
    def store_dir
      "uploads/report_card"
    end

    def filename
      (Time.now.to_f * 1000).round.to_s + '.csv'
    end
  end
end
