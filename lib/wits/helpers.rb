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

    def format_price(date, time, trading_period, price)
      {
        time: parse_nz_time(date, time),
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

    def parse_nz_time(date, time)
      tz = TZInfo::Timezone.get('Pacific/Auckland')

      # Timezone information of the Time object is ignored by TZInfo
      time = Time.parse("#{date} #{time}")

      # Output in local time
      tz.local_to_utc(time).localtime
    end
  end
end
