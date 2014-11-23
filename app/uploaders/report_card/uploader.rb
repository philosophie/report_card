# encoding: utf-8

module ReportCard
  class Uploader < CarrierWave::Uploader::Base
    def store_dir
      "uploads/report_card"
    end
  end
end
