require 'wits/nodes'

module Wits
  module FinalInterimPrices
    module ConvenienceMethods

      def self.extended(_base)
        Wits::Nodes.nodes.each do |node, name|
          # def ben2201
          create_prices_method(node.downcase, node)

          # def hay
          create_prices_method(node.downcase[0..2], node)

          # def halfway_bush
          create_prices_method(name.downcase.tr(' ', '_'), node)


          # def ben2201_prices
          create_prices_method("#{node.downcase}_prices", node)

          # def hay_prices
          create_prices_method("#{node.downcase[0..2]}_prices", node)

          # def halfway_bush_prices
          create_prices_method("#{name.downcase.tr(' ', '_')}_prices", node)
        end
      end

      private

      def self.create_prices_method(method_name, node)
        define_method method_name do |*args|
          prices(node, *args)
        end
      end
    end
  end
end
