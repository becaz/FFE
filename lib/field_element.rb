# frozen_string_literal: true

# Prime field element
class FieldElement
  attr_reader :value, :prime

  def initialize(args = {})
    @value = args.fetch(:value)
    @prime = args.fetch(:prime)

    return if value >= 0 && value < prime

    msg = "Value #{value} is not in field range 0 to #{prime - 1}"
    raise ArgumentError, msg
  end

  def to_s
    "FE#{prime}(#{value})"
  end

  def to_hex
    value.to_s(16)
  end

  def == other
    return false if other.nil?

    other.value == value && other.prime == prime
  end

  def != other
    return true if other.nil?

    other.value != value || other.prime != prime
  end

  def + other
    if prime == other.prime
      return FieldElement.new(prime: prime, value: (value + other.value) % prime)
    else
      raise TypeError, 'Cannot add two elemnts of different fields'
    end
  end

  def - other
    if prime == other.prime
      return FieldElement.new(prime: prime, value: (value - other.value) % prime)
    else
      raise TypeError, 'Cannot subtract two elements in different fields'
    end
  end

  def -@
    return self if value == 0
    FieldElement.new(value: prime - value, prime: prime)
  end

  def * other
    if other.is_a? Integer
      return FieldElement.new(prime: prime, value: (value * other) % prime)
    elsif prime == other.prime
      return FieldElement.new(prime: prime, value: (value * other.value) % prime)
    else
      raise TypeError, 'Cannot multiply two different in different fields'
    end
  end

  def coerce other
    return self, other
  end

  def ** exp
    if value == 0 && exp == 0
      raise ArgumentError, 'Cannot raise 0 to 0'
    else
      k = exp % (prime - 1)
      return FieldElement.new(prime: prime,
                              value: modexp(value, k, prime))
    end
  end

  def zero?
    value == 0
  end

  def / other
    if other.value == 0
      raise ZeroDivisionError,
            'Cannot compute multiplicative inverse of 0'
    else
      self * other**(-1)
    end
  end

  private

  def modexp(val, exp, mod)
    res = 1
    while exp > 0 do
      res = (res * val) % mod if exp.odd?
      val = (val * val) % mod
      exp >>= 1
    end
    res
  end

end
