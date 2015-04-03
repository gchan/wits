module Wits
  module Nodes
    extend self

    NODES = {
      BEN2201: 'Benmore',
      HWB2201: 'Halfway Bush',
      HAY2201: 'Haywards',
      HLY2201: 'Huntly',
      INV2201: 'Invercargill',
      ISL2201: 'Islington',
      OTA2201: 'Otahuhu',
      STK2201: 'Stoke',
      SFD2201: 'Stratford',
      TUI1101: 'Tuai',
      WKM2201: 'Whakamaru'
    }.freeze

    NODE_NAMES = NODES.invert.freeze

    SHORT_CODES = {
      BEN: 'BEN2201',
      HWB: 'HWB2201',
      HAY: 'HAY2201',
      HLY: 'HLY2201',
      INV: 'INV2201',
      ISL: 'ISL2201',
      OTA: 'OTA2201',
      STK: 'STK2201',
      SFD: 'SFD2201',
      TUI: 'TUI1101',
      WKM: 'WKM2201'
    }.freeze

    def nodes
      NODES
    end

    def node_names
      NODE_NAMES
    end

    def node_short_codes
      SHORT_CODES
    end
  end
end
