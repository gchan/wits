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

    def self.extended(base)
      base.extend Helpers
      base.extend ConvenienceMethods
    end

    def prices(node, date = Date.today - 2)
      node = format_node(node)
      date = format_date(date)

      request_prices(node, date)
    end

    private

    def request_prices(node, date)
      response = Wits::Client.get_csv do |request|
        request.url(
          'comitFta/ftaPage.download',
          pNode: node,
          pDate: date
        )
      end

      parse_prices_csv(response.body)
    end

    def parse_prices_csv(csv)
      csv = CSV.parse(csv)

      price_type, node, date = read_prices_header(csv)
      prices                 = process_prices(csv, date)

      format_prices(node, date, prices, price_type)
    rescue StandardError => error
      raise Wits::Error::ParsingError.new(error)
    end

    def read_prices_header(csv)
      header_regexp = %r{(.*) Prices for Node (.{3}\d{4}) on (\d{2}\/\d{2}\/\d{4})}

      header = csv.shift.shift
      price_type, node, date = header.match(header_regexp).captures

      date = Date.parse date

      csv.shift # discard second header

      [price_type, node, date]
    end

    def process_prices(csv, date)
      csv.map do |time, trading_period, price|
        format_price(date, time, trading_period, price)
      end
    end
  end
end
