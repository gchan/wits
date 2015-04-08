require 'tzinfo'
require 'wits/nodes'

module Wits
  module Helpers
    private

    def format_node(node)
      node = node.to_s.upcase

      if node.length == 3
        Wits::Nodes.node_short_codes[node.to_sym]
      else
        node
      end
    end

    def format_date(date)
      if date.respond_to?(:strftime)
        date.strftime('%d/%m/%Y')
      else
        date
      end
    end

    def format_price(date, time, trading_period, price, repeated_time)
      {
        time: parse_nz_time(date, time, repeated_time),
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
        prices: prices.sort_by { |price| price[:time] }
      }
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
  end
end
