require 'csv'
require 'wits/nodes'
require 'wits/helpers'
require 'wits/client'
require 'wits/error'
require 'wits/final_interim_prices/convenience_methods'

module Wits
  module FinalInterimPrices
    extend self
    extend Helpers
    extend ConvenienceMethods
    include PriceCodes

    def self.extended(base)
      base.extend Helpers
      base.extend ConvenienceMethods
    end

    def prices(node, date = nz_current_date - 3, type = FINAL)
      csv = request_prices(node, date, type)
      parse_csv(csv, type)
    end

    def interim_prices(node, date = nz_current_date - 1)
      prices(node, date, INTERIM)
    end
  end
end
