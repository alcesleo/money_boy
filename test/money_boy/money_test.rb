require "test_helper"
require "money_boy"

class MoneyTest < Minitest::Test
  include MoneyBoy

  def setup
    Money.conversion_rates = {
      "EUR" => {
        "USD" => 1.11,
        "BTC" => 0.0047,
        "SEK" => 10,
      },
    }
  end

  def test_equality
    assert_equal 9.eur, 9.eur
    assert_equal 9.eur, 9.0.eur

    refute_equal 9.eur, 10.eur
    refute_equal 9.eur, 9.usd
    refute_equal 9.eur, Object.new
    refute_equal 9.eur, nil
  end

  def test_eql
    assert 9.eur.eql?(9.eur), "Expected #eql? to do the same as #=="
  end

  def test_hash
    assert_equal 9.eur.hash, 9.eur.hash
  end

  def test_inspect
    assert_equal "50.00 EUR", 50.eur.inspect
  end

  def test_conversions
    assert_equal 9.eur, 9.eur.convert_to("EUR")

    assert_equal 9.99.usd, 9.eur.convert_to("USD")
    assert_equal 9.eur, 9.99.usd.convert_to("EUR")

    assert_equal 5.7.eur, 57.sek.convert_to("EUR")

    assert_raises(ArgumentError) { 5.eur.convert_to("UNKNOWN") }
  end

  def test_comparisons
    assert_operator 9.eur, :<, 10.eur
    assert_operator 10.eur, :>, 10.usd
    assert_operator 9.eur, :==, 9.99.usd
    assert_operator 9.99.usd, :==, 9.eur

    assert_raises(ArgumentError) { 5.eur < Money.new(5, "UNKNOWN") }
  end

  def test_arithmetic
    assert_equal 9.eur, 5.eur + 4.eur
    assert_equal 1.eur, 5.eur - 4.eur
    assert_equal 10.eur, 5.50.eur + 5.usd
    assert_equal 10.eur, 5.usd + 5.50.eur

    assert_raises(ArgumentError) { 5.eur + 5 }
    assert_raises(ArgumentError) { 5.eur - 5 }
  end

  def test_encapsulation
    assert_raises(NoMethodError) { 9.eur.amount }
    assert_raises(NoMethodError) { 9.eur.currency }
    assert_raises(NoMethodError) { 9.eur.conversion_rates }
    assert_raises(NoMethodError) { Money.conversion_rates }
  end
end
