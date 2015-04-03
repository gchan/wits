require 'wits/nodes'

module Wits
  module FiveMinutePrices
    module ConvenienceMethods
      Wits::Nodes.nodes.each do |node, name|
        # def ben2201_five_minute_prices
        define_method "#{node.downcase}_five_minute_prices" do |*args|
          five_minute_prices(node, *args)
        end

        # def hay_five_minute_prices
        define_method "#{node.downcase[0..2]}_five_minute_prices" do |*args|
          five_minute_prices(node, *args)
        end

        # def halfway_bush_five_minute_prices
        define_method "#{name.downcase.tr(' ', '_')}_five_minute_prices" do |*args|
          five_minute_prices(node, *args)
        end


        # def ben2201_avgerage_five_minute_prices
        define_method "#{node.downcase}_average_five_minute_prices" do |*args|
          average_five_minute_prices(node, *args)
        end

        # def hay_avgerage_five_minute_prices
        define_method "#{node.downcase[0..2]}_average_five_minute_prices" do |*args|
          average_five_minute_prices(node, *args)
        end

        # def halfway_bush_avgerage_five_minute_prices
        define_method "#{name.downcase.tr(' ', '_')}_average_five_minute_prices" do |*args|
          average_five_minute_prices(node, *args)
        end
      end
    end
  end
end