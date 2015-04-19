require 'wits/nodes'

module Wits
  module FiveMinutePrices
    module ConvenienceMethods

      def self.extended(_base)
        Wits::Nodes.nodes.each do |node, name|
          # def ben2201_five_minute_prices
          create_five_min_method(node.downcase, node)

          # def hay_five_minute_prices
          create_five_min_method(node.downcase[0..2], node)

          # def halfway_bush_five_minute_prices
          create_five_min_method(name.downcase.tr(' ', '_'), node)


          # def ben2201_avgerage_five_minute_prices
          create_avg_five_min_method(node.downcase, node)

          # def hay_avgerage_five_minute_prices
          create_avg_five_min_method(node.downcase[0..2], node)

          # def halfway_bush_avgerage_five_minute_prices
          create_avg_five_min_method(name.downcase.tr(' ', '_'), node)
        end
      end

      private

      def self.create_five_min_method(method_prefix, node)
        define_method "#{method_prefix}_five_minute_prices" do |*args|
          five_minute_prices(node, *args)
        end
      end

      def self.create_avg_five_min_method(method_prefix, node)
        define_method "#{method_prefix}_average_five_minute_prices" do |*args|
          average_five_minute_prices(node, *args)
        end
      end
    end
  end
end
