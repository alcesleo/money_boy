require "bigdecimal"

module MoneyBoy
  # Understands an amount of a certain currency
  class Money
    include Comparable

    DECIMAL_PRECISION = 2

    private_class_method :new

    def self.conversion_rates=(conversion_rates)
      @conversion_rates = conversion_rates

      define_conversion_methods
      define_convenience_constructors
    end

    def initialize(amount, currency)
      @amount   = BigDecimal.new(amount.to_s)
      @currency = currency
    end

    def <=>(other)
      return nil unless other.is_a?(self.class)
      rounded_amount <=> other.convert_to(currency).rounded_amount
    end
    alias eql? ==

    def hash
      [amount, currency].hash
    end

    def inspect
      format("%.2f %s", amount, currency)
    end

    def +(other)
      fail ArgumentError unless other.is_a?(self.class)
      instantiate(amount + other.convert_to(currency).amount, currency)
    end

    def -@
      instantiate(-amount, currency)
    end

    def -(other)
      self + -other
    end

    def *(other)
      fail ArgumentError unless other.is_a?(Numeric)
      instantiate(amount * other, currency)
    end

    def /(other)
      fail ArgumentError unless other.is_a?(Numeric)
      instantiate(amount / other, currency)
    end

    protected

    attr_reader :amount, :currency

    def rounded_amount
      amount.round(DECIMAL_PRECISION)
    end

    def convert_to(target_currency)
      instantiate(
        amount * conversion_rate(currency, target_currency),
        target_currency,
      )
    end

    private

    def instantiate(amount, currency)
      self.class.send(:new, amount, currency)
    end

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

    def self.define_conversion_methods
      currencies.each do |currency|
        define_method("to_#{currency.downcase}") do
          convert_to(currency)
        end
      end
    end
    private_class_method :define_conversion_methods

    def self.define_convenience_constructors
      money_class = self
      currencies.each do |currency|
        next if Numeric.method_defined?(currency.downcase)

        Numeric.class_eval do
          define_method(currency.downcase) do
            money_class.send(:new, self, currency)
          end
        end
      end
    end
    private_class_method :define_convenience_constructors

    def self.currencies
      @conversion_rates.flat_map { |base, rates| [base] + rates.keys }
    end
    private_class_method :currencies
  end
end
