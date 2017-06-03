require "bigdecimal"

module MoneyBoy
  # Understands an amount of a certain currency
  class Money
    include Comparable

    DECIMAL_PRECISION = 2

    private_class_method :new

    def self.set_conversion_rates(base_currency, conversion_rates)
      @base_currency    = base_currency
      @conversion_rates = conversion_rates

      define_conversion_methods
      define_convenience_constructors

      nil
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
      convert_to(base_currency).rounded_amount.hash
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
      instantiate(converted_amount(target_currency), target_currency)
    end

    private

    def instantiate(amount, currency)
      self.class.send(:new, amount, currency)
    end

    def base_currency
      self.class.instance_variable_get(:@base_currency)
    end

    def conversion_rates
      self.class.instance_variable_get(:@conversion_rates)
    end

    def converted_amount(target_currency)
      amount_in_base_currency * conversion_rate(target_currency)
    end

    def amount_in_base_currency
      amount * (1.0 / conversion_rate(currency))
    end

    def conversion_rate(target_currency)
      return 1.0 if target_currency == base_currency
      conversion_rates.fetch(target_currency)
    end

    class << self
      private

      def define_conversion_methods
        currencies.each do |currency|
          conversion_method = "to_#{currency.downcase}"
          next if method_defined?(conversion_method)

          define_method(conversion_method) do
            convert_to(currency)
          end
        end
      end

      def define_convenience_constructors
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

      def currencies
        [@base_currency] + @conversion_rates.keys
      end
    end
  end
end
