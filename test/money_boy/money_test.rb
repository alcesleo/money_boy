require "test_helper"
require "money_boy"

class MoneyTest < Minitest::Test
  MoneyBoy::Money.set_conversion_rates(
    "EUR",
    "USD" => 1.11,
    "SEK" => 10,
  )

  def test_equality
    assert_equal 9.eur, 9.eur
    assert_equal 9.eur, 9.0.eur
    assert_equal 9.eur, 9.99.usd
    assert_equal 9.99.usd, 9.eur

    refute_equal 9.eur, 10.eur
    refute_equal 9.eur, 9.usd
    refute_equal 9.eur, Object.new
    refute_equal 9.eur, nil
  end

  def test_eql
    assert 9.eur.eql?(9.eur), "Expected #eql? to behave as #=="
  end

  def test_hash
    assert_equal 9.eur.hash, 9.eur.hash
    assert_equal 9.eur.hash, 9.99.usd.hash
  end

  def test_inspect
    assert_equal "50.00 EUR", 50.eur.inspect
  end

  def test_conversions
    assert_equal 9.eur, 9.eur.to_eur
    assert_equal 9.eur, 9.99.usd.to_eur
    assert_equal 9.99.usd, 9.eur.to_usd
    assert_equal 5.7.eur, 57.sek.to_eur
    assert_equal 90.sek, 9.99.usd.to_sek
    assert_equal 9.99.usd.to_sek, 90.sek
  end

  def test_comparisons
    assert_operator 9.eur, :<, 10.eur
    assert_operator 10.eur, :>, 10.usd

    assert_raises(ArgumentError) { 5.eur < 5 }
  end

  def test_arithmetic
    assert_equal 9.eur, 5.eur + 4.eur
    assert_equal 1.eur, 5.eur - 4.eur
    assert_equal 10.eur, 5.50.eur + 5.usd
    assert_equal 10.eur, 5.usd + 5.50.eur

    assert_raises(ArgumentError) { 5.eur + 5 }
    assert_raises(ArgumentError) { 5.eur - 5 }

    assert_equal 9.eur, 4.5.eur * 2
    assert_equal 4.5.eur, 9.eur / 2

    assert_raises(ArgumentError) { 1.eur * 1.eur }
    assert_raises(ArgumentError) { 1.usd / 1.usd }
  end

  def test_encapsulation
    assert_raises(NoMethodError) { 9.eur.amount }
    assert_raises(NoMethodError) { 9.eur.currency }
    assert_raises(NoMethodError) { 9.eur.conversion_rates }
    assert_raises(NoMethodError) { MoneyBoy::Money.conversion_rates }
    assert_raises(NoMethodError) { MoneyBoy::Money.new(1, "EUR") }
    assert_raises(NoMethodError) { MoneyBoy::Money.currencies }
    assert_raises(NoMethodError) { MoneyBoy::Money.define_conversion_methods }
    assert_raises(NoMethodError) { MoneyBoy::Money.define_convenience_constructors }
  end

  def test_set_conversion_rates
    assert_raises(RuntimeError) { MoneyBoy::Money.set_conversion_rates("USD", {}) }
  end
end
