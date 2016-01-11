require 'money_boy/version'
require 'money_boy/money'

module MoneyBoy
  def self.set_conversion_rates(conversion_rates)
    @conversion_rates = conversion_rates
  end

  def self.conversion_rates
    @conversion_rates
  end
end
