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

    def self.extended(base)
      base.extend Helpers
      base.extend ConvenienceMethods
    end

    def average_five_minute_prices(node, date = nz_current_date)
      five_minute_prices(node, date, :average)
    end

    def five_minute_prices(node, date = nz_current_date, type = :price )
      node = format_node(node)
      date = format_date(date)
      type = format_price_type(type)

      request_five_min_prices(node, date, type)
    end

    private

    def format_price_type(type)
      if type == :price
        'Price'
      else
        'Average'
      end
    end

    def request_five_min_prices(node, date, type)
      response = Wits::Client.get_csv do |request|
        request.url(
          'comitFta/five_min_prices.download',
          INchoice:    'SEL', # Mandatory
          INdate:       date,
          INgip:        node,
          INperiodfrom: 1,
          INperiodto:   50,
          INtype:       type
        )
      end

      parse_five_min_csv(response.body, type)
    end

    def parse_five_min_csv(csv, type)
      csv = CSV.parse(csv.sub("\r\n", "\n"))

      node, date = process_five_min_metadata(csv)
      prices     = process_five_min_prices(csv)
      price_type = 'Five Minute'

      price_type = "Average #{price_type}" if type == 'Average'

      format_prices(node, date, prices, price_type)
    rescue StandardError => error
      raise Wits::Error::ParsingError.new(error)
    end

    def process_five_min_metadata(csv)
      csv.shift # discard header

      node = csv.first[0]
      date = Date.parse csv.first[1]

      [node, date]
    end

    def process_five_min_prices(csv)
      times = []

      csv.map do |_node, date, trading_period, time, price, *_|
        repeated_time = times.include?(time)
        times << time

        format_price(date, time, trading_period, price, repeated_time)
      end
    end
  end
end
