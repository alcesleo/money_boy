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

    describe 'equality' do
      it 'is equal if both the amount and the currency is the same' do
        expect(subject).to eq Money.new(50, 'EUR')
      end

      it 'is not equal to a normal number' do
        expect(subject).not_to eq 50
      end

      it 'is equal if the amount differs by less than a cent' do
        expect(subject).to eq Money.new(50.003, 'EUR')
      end
    end

    describe 'conversions' do
      before do
        MoneyBoy.set_conversion_rates({ 'EUR' => { 'USD' => 1.11 } })
      end

      after do
        # Since this is globally set on the class, we need to tear down to make
        # sure tests can run in any order.
        MoneyBoy.set_conversion_rates(nil)
      end

      it 'converts to another known currency' do
        expect(subject.convert_to('USD')).to eq Money.new(55.5, 'USD')
      end

      it 'raises an error if the target currency is unknown' do
        fifty_btc = Money.new(50, 'Bitcoin')

        expect { subject.convert_to('EUR') }.to raise_exception(ConversionError, /Unknown exchange rate/)
      end
    end
  end
end
