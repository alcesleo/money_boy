require 'money_boy/version'

module MoneyBoy
  def self.set_conversion_rates(conversion_rates)
    @conversion_rates = conversion_rates
  end

  def self.conversion_rates
    @conversion_rates
  end
end
