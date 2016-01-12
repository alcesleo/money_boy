require 'money_boy/converter'

module MoneyBoy
  class Money
    include Comparable

    attr_reader :amount, :currency

    def initialize(amount, currency)
      @amount   = amount.round(2)
      @currency = currency
    end

    def inspect
      "#{'%.2f' % amount} #{currency}"
    end

    def <=>(other)
      return false unless Money === other
      other = other.convert_to(self.currency)
      amount <=> other.amount
    rescue ConversionError
      nil # Invalid conversions are supposed to return nil to comply with Comparable
    end
    alias_method :eql?, :==

    def convert_to(target_currency)
      Converter.new.convert(self, target_currency)
    end

    # Define arithmetic operations
    %i{ + - * / }.each do |operator|
      define_method(operator) do |other|
        other_amount = case other
                       when Money   then other.convert_to(currency).amount
                       when Numeric then other
                       else fail ArgumentError, 'Incompatible types'
                       end

        Money.new(amount.public_send(operator, other_amount), currency)
      end
    end
  end
end
