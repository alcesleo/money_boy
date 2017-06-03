# MoneyBoy

## Development

Run the tests

    $ bundle exec rake

## Specification

```ruby
MoneyBoy::Money.set_conversion_rates("EUR", {
    "USD" => 1.11,
    "SEK" => 10,
  }
)

# Instantiate money objects:
fifty_eur = 50.eur

# It will not reveal its internal variables since that breaks encapsulation
fifty_eur.amount   # => NoMethodError
fifty_eur.currency # => NoMethodError

fifty_eur.inspect  # => "50.00 EUR"

# Convert to a different currency
fifty_eur.to_usd # => 55.50 USD

# Perform operations in different currencies:

twenty_dollars = 20.usd

# Arithmetics:

fifty_eur + twenty_dollars # => 68.02 EUR
fifty_eur - twenty_dollars # => 31.98 EUR
fifty_eur / 2              # => 25.00 EUR
twenty_dollars * 3         # => 60.00 USD

# Comparisons (also in different currencies):

twenty_dollars == 20.usd # => true
twenty_dollars == 30.usd # => false

fifty_eur_in_usd = fifty_eur.to_usd
fifty_eur_in_usd == fifty_eur          # => true

twenty_dollars > 5.usd                 # => true
twenty_dollars < fifty_eur             # => true
```
