require "minitest/autorun"
require 'strscan'
require_relative '../lib/chemical_weight'
class ChemicalWeightTest < Minitest::Test
  def setup
    @cw = ChemicalWeight.new(formulae: "CH3", scanner: StringScanner)
  end

  def test_atomic_mass
    assert_equal @cw.atomic_mass("C"), 12.011
  end

  def test_parse
    assert_equal ChemicalWeight.new(formulae: "KMnO4", scanner: StringScanner).parse, {"O" => 4, "Mn" => 1, "K" => 1}
    assert_equal ChemicalWeight.new(formulae: "C6H12O6", scanner: StringScanner).parse, {"O" => 6, "H" => 12, "C" => 6}
    assert_equal ChemicalWeight.new(formulae: "H2SO4", scanner: StringScanner).parse, {"O" => 4, "S" => 1, "H" => 2}
    assert_equal ChemicalWeight.new(formulae: "CaCO3", scanner: StringScanner).parse, {"O" => 3, "C" => 1, "Ca" => 1}
    assert_equal ChemicalWeight.new(formulae: "(CH3)2CHOH", scanner: StringScanner).parse, {"H" => 8, "O" => 1, "C" => 3}
  end

  def test_mass
    assert_equal ChemicalWeight.new(formulae: "KMnO4", scanner: StringScanner).mass.round, 158
    assert_equal ChemicalWeight.new(formulae: "C6H12O6", scanner: StringScanner).mass.round, 180
    assert_equal ChemicalWeight.new(formulae: "H2SO4", scanner: StringScanner).mass.round, 98
    assert_equal ChemicalWeight.new(formulae: "CaCO3", scanner: StringScanner).mass.round, 100
    assert_equal ChemicalWeight.new(formulae: "(CH3)2CHOH", scanner: StringScanner).mass.round, 60
  end
end
