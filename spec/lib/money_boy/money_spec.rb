require 'spec_helper'
require 'money_boy/money'

module MoneyBoy
  describe Money do
    subject { described_class.new(50, 'EUR') }

    it 'reports amount' do
      expect(subject.amount).to eq 50
    end

    it 'reports currency' do
      expect(subject.currency).to eq 'EUR'
    end

    it 'has a nice inspect-representation' do
      expect(subject.inspect).to eq '50.00 EUR'
    end
  end
end
