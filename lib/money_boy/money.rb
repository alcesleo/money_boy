module MoneyBoy
  class Money
    attr_reader :amount, :currency
    protected :amount, :currency

    def initialize(amount, currency)
      @amount = amount
      @currency = currency
    end

    def ==(other)
      return false unless other.is_a?(self.class)
      amount == other.amount && currency == other.currency
    end
    alias eql? ==

    def hash
      [amount, currency].hash
    end
  end
end
