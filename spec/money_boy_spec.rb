require 'spec_helper'

describe MoneyBoy do
  it 'has a version number' do
    expect(MoneyBoy::VERSION).not_to be nil
  end

  it 'can set the global conversion rates' do
    conversion_rates = double

    described_class.set_conversion_rates(conversion_rates)

    expect(described_class.conversion_rates).to eq conversion_rates
  end
end
