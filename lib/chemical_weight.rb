require 'json'
  class ChemicalWeight
    def initialize(formulae:, scanner:)
      @formulae = formulae
      @scanner = scanner.new(formulae.reverse)
    end

    def reversed_scanner
      @scanner
    end

    def atomic_mass(element)
      json_data["elements"].find { |k, _v| k["symbol"]== element }["atomic_mass"]
    end

    def json_data
      @json_data ||= JSON.load File.read("data/periodic_table.json")
    end

    # (CH3)2CHOH => "HOHC2)3HC(" =>  {"H" => 8, "O" => 1, "C" => 3}
    def parse(scanner: reversed_scanner, multiplier: 1, hash: {}, ratio: 1)
      return if scanner.eos?
      if scanner.scan_full(/(\d+)/, true, false)
        ratio = scanner[1].reverse.to_i
      end
      if scanner.scan_full(/([a-z]?[A-Z])/, true, false)
        hash[scanner[1].reverse] = hash[scanner[1].reverse].to_i + ratio * multiplier
        ratio = 1
      end
      if scanner.scan_full(/\)/, true, false)
        multiplier = multiplier * ratio
        ratio = 1
      end
      if scanner.scan_full(/\(/, true, false)
        multiplier = 1
      end
      parse(scanner: scanner, multiplier: multiplier, hash: hash, ratio: ratio)
      hash
    end

    def mass(hash: parse)
     hash.inject(0) { |total, (k, v)| total + v * atomic_mass(k)}
    end
  end