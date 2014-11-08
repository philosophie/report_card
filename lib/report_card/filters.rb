module ReportCard
  module Filters
    extend ActiveSupport::Concern

    included do
      include ActiveAttr::Model
    end
  end
end
