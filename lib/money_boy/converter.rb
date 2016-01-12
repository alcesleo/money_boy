require 'money_boy'
require 'money_boy/money'
require 'money_boy/errors'

module MoneyBoy
  class Converter
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

    def conversion_rates
      @conversion_rates || {}
    end

    def conversion_rate(from, to)
      if conversion_rates[from] && conversion_rates[from][to]
        conversion_rates[from][to]
      elsif conversion_rates[to] && conversion_rates[to][from]
        1.0 / conversion_rates[to][from]
      else
        fail ConversionError, "Unknown exchange rate"
      end
    end
  end
end
