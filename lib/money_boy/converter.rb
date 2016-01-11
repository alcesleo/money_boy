require 'money_boy/money'

module MoneyBoy
  ConversionError = Class.new(StandardError)

  class Converter
    attr_reader :conversion_rates

    def initialize(conversion_rates)
      @conversion_rates = conversion_rates
    end

    def convert(money, target_currency)
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
        raise ConversionError, "Unknown exchange rate"
    end
  end
end
