require 'spec_helper'

describe Wits::Nodes do
  describe 'NODES' do
    it 'is a hash of nodes' do
      nodes = Wits::Nodes::NODES

      expect(nodes).to be_a(Hash)
      expect(nodes[:BEN2201]).to eq 'Benmore'
    end

    it 'is frozen' do
      expect(Wits::Nodes::NODES.frozen?).to be_truthy
    end
  end

  describe 'NODE_NAMES' do
    it 'is a hash of nodes' do
      node_names = Wits::Nodes::NODE_NAMES

      expect(node_names).to be_a(Hash)
      expect(node_names['Benmore']).to eq :BEN2201
    end

    it 'is frozen' do
      expect(Wits::Nodes::NODES.frozen?).to be_truthy
    end
  end

  describe 'SHORT_CODES' do
    it 'is a hash of short codes' do
      nodes = Wits::Nodes::SHORT_CODES

      expect(nodes).to be_a(Hash)
      expect(nodes[:BEN]).to eq 'BEN2201'
    end

    it 'is frozen' do
      expect(Wits::Nodes::SHORT_CODES.frozen?).to be_truthy
    end
  end

  describe '.nodes' do
    it 'returns NODES' do
      expect(Wits::Nodes.nodes).to eq Wits::Nodes::NODES
    end
  end

  describe '.node_names' do
    it 'returns NODE_NAMES' do
      expect(Wits::Nodes.node_names).to eq Wits::Nodes::NODE_NAMES
    end
  end

  describe '.node_short_codes' do
    it 'returns SHORT_CODES' do
      expect(Wits::Nodes.node_short_codes).to eq Wits::Nodes::SHORT_CODES
    end
  end

  context 'when extended' do
    before :all do
      class MyClass
        extend Wits::Nodes
      end
    end

    it 'makes the .nodes method available on the extending Class or Module' do
      expect(MyClass.nodes).to eq Wits::Nodes.nodes
    end

    it 'makes the .node_names method available on the extending Class or Module' do
      expect(MyClass.node_names).to eq Wits::Nodes.node_names
    end

    it 'makes the .node_short_codes method available on the extending Class or Module' do
      expect(MyClass.node_short_codes).to eq Wits::Nodes.node_short_codes
    end
  end
end
