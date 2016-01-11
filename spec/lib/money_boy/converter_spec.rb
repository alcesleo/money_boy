require 'money_boy/converter'
require 'money_boy/money'

module MoneyBoy
  describe Converter do
    let(:conversion_rates) { { 'EUR' => { 'USD' => 1.11 } } }
    let(:converter)        { Converter.new(conversion_rates) }

    it 'converts a Money object to a known currency' do
      fifty_euro = Money.new(50, 'EUR')

      expect(converter.convert(fifty_euro, 'USD')).to eq Money.new(55.5, 'USD')
    end

    it 'is a no-op to convert to the same currency' do
      fifty_euro = Money.new(50, 'EUR')

      expect(converter.convert(fifty_euro, 'EUR')).to eq fifty_euro
    end

    it 'raises an error if the target currency rate is unknown' do
      fifty_euro = Money.new(50, 'EUR')

      expect { converter.convert(fifty_euro, 'Bitcoin') }.to raise_exception(ConversionError, /Unknown exchange rate/)
    end

    it 'raises an error if the base currency rate is unknown' do
      fifty_btc = Money.new(50, 'Bitcoin')

      expect { converter.convert(fifty_btc, 'EUR') }.to raise_exception(ConversionError, /Unknown exchange rate/)
    end
  end
end
