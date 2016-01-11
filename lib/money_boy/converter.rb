require 'money_boy/money'
require 'money_boy/errors'

module MoneyBoy
  class Converter
    attr_reader :conversion_rates

    def initialize(conversion_rates = MoneyBoy.conversion_rates)
      @conversion_rates = conversion_rates
    end

    def convert(money, target_currency)
      return money if money.currency == target_currency

      Money.new(
        money.amount * conversion_rate(money.currency, target_currency),
        target_currency
      )
    end

    private

    def conversion_rate(from, to)
      # TODO: Use Hash#dig when we can use Ruby 2.3
      conversion_rates[from] and
        conversion_rates[from][to] or
        fail ConversionError, "Unknown exchange rate"
    end
  end
end
