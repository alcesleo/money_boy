module MoneyBoy
  class Money
    attr_reader :amount, :currency
    protected :amount, :currency

    class << self
      attr_writer :conversion_rates
    end

    def initialize(amount, currency)
      @amount   = amount.round(2)
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

    def convert_to(target_currency)
      self.class.new(
        amount * conversion_rate(currency, target_currency),
        target_currency,
      )
    end

    private

    def conversion_rates
      self.class.instance_variable_get(:@conversion_rates)
    end

    def conversion_rate(from, to)
      return 1.0 if from == to

      if conversion_rates[from] && conversion_rates[from][to]
        conversion_rates[from][to]
      elsif conversion_rates[to] && conversion_rates[to][from]
        1.0 / conversion_rates[to][from]
      else
        fail ArgumentError, "Unknown conversion rate"
      end
    end
  end
end
