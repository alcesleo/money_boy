require 'money_boy/converter'

module MoneyBoy
  class Money
    attr_reader :amount, :currency

    def initialize(amount, currency)
      @amount   = amount.round(2)
      @currency = currency
    end

    def inspect
      "#{'%.2f' % amount} #{currency}"
    end

    def ==(other)
      return false unless Money === other
      other = other.convert_to(self.currency)
      amount == other.amount
    end
    alias_method :eql?, :==

    def convert_to(target_currency)
      Converter.new.convert(self, target_currency)
    end

    def +(other)
      Money.new(amount + other.convert_to(currency).amount, currency)
    end

    def -(other)
      Money.new(amount - other.convert_to(currency).amount, currency)
    end

    def *(other)
      Money.new(amount * other.convert_to(currency).amount, currency)
    end

    def /(other)
      Money.new(amount / other.convert_to(currency).amount, currency)
    end
  end
end
