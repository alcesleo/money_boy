require "test_helper"
require "money_boy"

class MoneyTest < Minitest::Test
  include MoneyBoy

  def setup
    Money.conversion_rates = {
      "EUR" => {
        "USD" => 1.11,
        "BTC" => 0.0047,
      },
    }
  end

  def test_equality
    assert_equal Money.new(9, "EUR"), Money.new(9, "EUR")
    assert_equal Money.new(9, "EUR"), Money.new(9.0, "EUR")

    refute_equal Money.new(9, "EUR"), Money.new(10, "EUR")
    refute_equal Money.new(9, "EUR"), Money.new(9, "USD")
    refute_equal Money.new(9, "EUR"), Object.new
    refute_equal Money.new(9, "EUR"), nil
  end

  def test_eql
    assert Money.new(9, "EUR").eql?(Money.new(9, "EUR")), "Expected #eql? to do the same as #=="
  end

  def test_hash
    assert_equal Money.new(9, "EUR").hash, Money.new(9, "EUR").hash
  end

  def test_conversions
    assert_equal Money.new(5.55, "USD"), Money.new(5, "EUR").convert_to("USD")
    assert_equal Money.new(5, "EUR"), Money.new(5.55, "USD").convert_to("EUR")
  end

  def test_encapsulation
    assert_raises(NoMethodError) { Money.new(9, "EUR").amount }
    assert_raises(NoMethodError) { Money.new(9, "EUR").currency }
    assert_raises(NoMethodError) { Money.new(9, "EUR").conversion_rates }
    assert_raises(NoMethodError) { Money.conversion_rates }
  end
end
