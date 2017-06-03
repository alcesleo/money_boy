module MoneyBoy
  class Money
    attr_reader :amount, :currency
    protected :amount, :currency

    class << self
      attr_writer :conversion_rates

      attr_reader :conversion_rates
      private :conversion_rates
    end

    def initialize(amount, currency)
      @amount   = amount
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

    def convert_to(currency); end
  end
end
