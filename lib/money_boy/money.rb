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
      [amount, currency] == [other.amount, other.currency]
    end
    alias_method :eql?, :==
  end
end
