require 'spec_helper'
require 'money_boy/money'

module MoneyBoy
  describe Money do
      before(:all) do
        MoneyBoy.set_conversion_rates({ 'EUR' => { 'USD' => 1.11 } })
      end

      after(:all) do
        # Since this is globally set on the class, we need to tear down to make
        # sure other tests are not affected by this.
        MoneyBoy.set_conversion_rates(nil)
      end

    let(:fifty_euro) { described_class.new(50, 'EUR') }

    it 'reports amount' do
      expect(fifty_euro.amount).to eq 50
    end

    it 'reports currency' do
      expect(fifty_euro.currency).to eq 'EUR'
    end

    it 'has a nice inspect-representation' do
      expect(fifty_euro.inspect).to eq '50.00 EUR'
    end

    describe 'equality' do
      it 'is equal if both the amount and the currency is the same' do
        expect(fifty_euro).to eq Money.new(50, 'EUR')
      end

      it 'is not equal to a normal number' do
        expect(fifty_euro).not_to eq 50
      end

      it 'is equal if the amount differs by less than a cent' do
        expect(fifty_euro).to eq Money.new(50.003, 'EUR')
      end

      it 'is equal if the Money objects have the same amount when converted to the same currency' do
        expect(Money.new(55.50, 'USD')).to eq fifty_euro
      end

      it 'handles less/greater than' do
        expect(Money.new(49, 'EUR')).to be < fifty_euro
        expect(Money.new(49, 'EUR')).not_to be > fifty_euro
      end

      it 'handles less/greater than with other currencies' do
        expect(Money.new(51, 'USD')).to be < fifty_euro
      end
    end

    describe 'conversions' do
      it 'converts to another known currency' do
        expect(fifty_euro.convert_to('USD')).to eq Money.new(55.5, 'USD')
      end

      it 'raises an error if the target currency is unknown' do
        fifty_btc = Money.new(50, 'Bitcoin')

        expect { fifty_btc.convert_to('EUR') }.to raise_exception(ConversionError, /Unknown exchange rate/)
      end
    end

    describe 'arithmetic' do
      let(:seven_euro) { Money.new(7, 'EUR') }

      it 'handles addition' do
        expect(fifty_euro + seven_euro).to eq Money.new(57, 'EUR')
      end

      it 'handles subtraction' do
        expect(fifty_euro - seven_euro).to eq Money.new(43, 'EUR')
      end

      it 'handles multiplication' do
        expect(fifty_euro * seven_euro).to eq Money.new(350, 'EUR')
      end

      it 'handles division' do
        expect(fifty_euro / seven_euro).to eq Money.new(7.14, 'EUR')
      end

      it 'handles arithmetic with differing currencies' do
        hundred_dollar = Money.new(100, 'USD')
        expect(hundred_dollar - fifty_euro).to eq Money.new(44.50, 'USD')
      end
    end
  end
end
