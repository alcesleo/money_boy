module MoneyBoy
  class Money
    attr_reader :amount, :currency

    def initialize(amount, currency)
      @amount   = amount
      @currency = currency
    end

    def inspect
      "#{'%.2f' % amount} #{currency}"
    end
  end
end
