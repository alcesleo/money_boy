module MoneyBoy
  class Money
    include Comparable

    attr_reader :amount, :currency
    protected :amount, :currency

    @disable_monkey_patches = false
    def self.disable_monkey_patches!
      @disable_monkey_patches = true
    end

    def self.conversion_rates=(conversion_rates)
      @conversion_rates = conversion_rates
      define_convenience_constructors unless @disable_monkey_patches
    end

    def initialize(amount, currency)
      @amount   = amount.round(2)
      @currency = currency
    end

    def <=>(other)
      return nil unless other.is_a?(self.class)
      amount <=> other.convert_to(currency).amount
    end
    alias eql? ==

    def hash
      [amount, currency].hash
    end

    def inspect
      format("%.2f %s", amount, currency)
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

    def self.define_convenience_constructors
      money_class = self
      @conversion_rates.flat_map { |base, rates| [base] + rates.keys }.each do |currency|
        next if Numeric.method_defined?(currency.downcase)

        Numeric.class_eval do
          define_method currency.downcase do
            money_class.new(self, currency)
          end
        end
      end
    end
    private_class_method :define_convenience_constructors
  end
end

module MoneyBoy
  module MoneyExtensions
    refine Numeric do
    end
  end
end
