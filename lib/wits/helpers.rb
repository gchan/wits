require 'tzinfo'
require 'wits/nodes'
require 'wits/price_codes'

module Wits
  module Helpers
    private

    def format_price_type(type)
      Wits::PriceCodes::PRICE_TYPES[type]
    end

    def price_description(type_code)
      Wits::PriceCodes::PRICE_DESCRIPTION[type_code]
    end

    def format_node(node)
      node = node.to_s.upcase

      if node.length == 3
        Wits::Nodes.node_short_codes[node.to_sym]
      else
        node
      end
    end

    def format_date(date)
      if date.is_a?(String)
        Time.parse(date).to_date.iso8601
      else
        date.to_date.iso8601
      end
    end

    def format_price_thirty_min(date, _time, trading_period, price, repeated_time)
      {
        time: parse_nz_time(date, '', repeated_time) + 60 * 30 * (trading_period.to_i - 1),
        trading_period: trading_period.to_i,
        price: price.to_f
      }
    end

    def format_price_five_minute(_date, time, trading_period, price, repeated_time)
      {
        time: parse_nz_time(time[0..9], time[0..-4], repeated_time) - 5 * 60,
        trading_period: trading_period.to_i,
        price: price.to_f
      }
    end

    def format_prices(node, date, prices, price_type)
      {
        node_code: node,
        node_short_code: node[0..2],
        node_name: Wits::Nodes.nodes[node.to_sym],
        price_type: price_type,
        date: date,
        prices: prices
      }
    end

    def process_metadata(csv)
      csv.shift # discard header

      node = csv.first[0]
      date = Date.parse csv.first[1]

      [node, date]
    end

    def process_prices(csv)
      times = []

      csv.map do |_node, date, trading_period, price, _, _, time, type|
        repeated_time = times.include?(time)
        times << time

        if type == 'I'
          format_price_five_minute(date, time, trading_period, price, repeated_time)
        else
          format_price_thirty_min(date, time, trading_period, price, repeated_time)
        end
      end
    end

    def request_prices(node, date, type)
      node = format_node(node)
      date = format_date(date)
      type = format_price_type(type)

      response = Wits::Client.get_csv do |request|
        request.url('download/prices')

        request.params['search_form[date_from]'] = date
        request.params['search_form[date_to]'] = date
        request.params['search_form[tp_from]'] = 1
        # Maximum trading period is 50 but it doesn't appear
        # to work for average prices (only half the data is returned)
        request.params['search_form[tp_to]'] = 100
        request.params['search_form[nodes]'] = [node]
        request.params['search_form[market_types]'] = ['E']
        request.params['search_form[run_types]'] = [type]
      end

      response.body
    end

    def parse_csv(csv, type)
      csv = CSV.parse(csv.sub("\r\n", "\n"))

      node, date = process_metadata(csv)
      prices     = process_prices(csv)
      price_type = price_description(type)

      format_prices(node, date, prices, price_type)
    rescue StandardError => error
      raise Wits::Error::ParsingError, error
    end

    def parse_nz_time(date, time, repeated_time)
      date = Date.parse(date) unless date.is_a?(Date)

      # TimezonePeriod for local Time (midnight)
      tz_period = nz_time_zone.period_for_local(date.to_time)

      # Assume we transitioned between NZST and NZDT if
      # a time is repeated
      dst = tz_period.dst?
      dst = !dst if repeated_time

      # Time zone information of the Time object is ignored by TZInfo
      time = Time.parse("#{date} #{time}")

      # Output in local time
      nz_time_zone.local_to_utc(time, dst).localtime
    end

    def nz_time_zone
      @nz_time_zone ||= TZInfo::Timezone.get('Pacific/Auckland')
    end

    def nz_current_date
      nz_time_zone.utc_to_local(Time.now.utc).to_date
    end
  end
end
