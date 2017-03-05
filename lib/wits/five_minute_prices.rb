require 'csv'
require 'wits/nodes'
require 'wits/helpers'
require 'wits/client'
require 'wits/error'
require 'wits/five_minute_prices/convenience_methods'

module Wits
  module FiveMinutePrices
    extend self
    extend Helpers
    extend ConvenienceMethods
    include PriceCodes

    def self.extended(base)
      base.extend Helpers
      base.extend ConvenienceMethods
    end

    def five_minute_prices(node, date = nz_current_date, type = FIVE_MINUTE)
      csv = request_prices(node, date, type)
      parse_csv(csv, type)
    end

    def average_five_minute_prices(node, date = nz_current_date)
      five_minute_prices(node, date, AVERAGE)
    end
  end
end
