require 'wits/nodes'

module Wits
  module FinalInterimPrices
    module ConvenienceMethods
      Wits::Nodes.nodes.each do |node, name|
        # def ben2201
        define_method node.downcase do |*args|
          prices(node, *args)
        end

        # def hay
        define_method node.downcase[0..2] do |*args|
          prices(node, *args)
        end

        # def halfway_bush
        define_method name.downcase.tr(' ', '_') do |*args|
          prices(node, *args)
        end


        # def ben2201_prices
        define_method "#{node.downcase}_prices" do |*args|
          prices(node, *args)
        end

        # def hay_prices
        define_method "#{node.downcase[0..2]}_prices" do |*args|
          prices(node, *args)
        end

        # def halfway_bush_prices
        define_method "#{name.downcase.tr(' ', '_')}_prices" do |*args|
          prices(node, *args)
        end
      end
    end
  end
end
