require "test_helper"
require "money_boy"

class MoneyTest < Minitest::Test
  include MoneyBoy

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
end
