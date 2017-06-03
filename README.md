# MoneyBoy

## Development

Run the tests

    $ bundle exec rake

## Specification

```ruby
Money.conversion_rates = {
  "EUR" => {
    "USD"     => 1.11,
    "Bitcoin" => 0.0047,
  }
}

# Instantiate money objects:
fifty_eur = 50.eur

# It will not reveal its internal variables since that breaks encapsulation
fifty_eur.amount   # => NoMethodError
fifty_eur.currency # => NoMethodError

fifty_eur.inspect  # => "50.00 EUR"

# Convert to a different currency
fifty_eur.convert_to('USD') # => 55.50 USD

# Perform operations in different currencies:

twenty_dollars = Money.new(20, 'USD')

# Arithmetics:

fifty_eur + twenty_dollars # => 68.02 EUR
fifty_eur - twenty_dollars # => 31.98 EUR
fifty_eur / 2              # => 25 EUR
twenty_dollars * 3         # => 60 USD

# Comparisons (also in different currencies):

twenty_dollars == Money.new(20, 'USD') # => true
twenty_dollars == Money.new(30, 'USD') # => false

fifty_eur_in_usd = fifty_eur.convert_to('USD')
fifty_eur_in_usd == fifty_eur          # => true

twenty_dollars > Money.new(5, 'USD')   # => true
twenty_dollars < fifty_eur             # => true
```
