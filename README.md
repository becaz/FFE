# Prime Fields
This project bears educational purpose, and can be used for proof of concepts or small experiments. We implement a prime field element and arithmetic operations on these elements.

## Definition
Let *p* be a prime number and consider a set *F*<sub>*p*</sub> = {1, 2, ..., *p*-1} with the following operations defined on the its elements

* Addition: *a + b* mod *p*
* Subtraction: *a - b* mod *p*
* Multiplication: *ab* mod *p*
* Inverse: for any element *a* in *Fp* different from 0 there is a unique *b* such that *ab* mod *p* = 1.  

The prime number *p* is said to be the *order* of the fiedl *Fp*.
## Setup a project folder

Create a folder `ffe` and inside this folder create a `Rakefile`
```
require 'rake/testtask'

task default: 'test'

Rake::TestTask.new do |task|
  task.libs << "test"
  task.pattern = 'test/**/test_*.rb'
end
```
and the `test` folder. We will use `minitest`, so inside the `test` folder create the `test_helper.rb` file

```
require 'minitest/autorun'

Dir[File.dirname(__FILE__) + '/../lib/*.rb'].each do |file|
  require File.basename(file, File.extname(file))
end
```

Run `rake test` while at the root level inside the `ffe` folder. If everything is alright then we should get
```
...
Finished in 0.000632s, 0.0000 runs/s, 0.0000 assertions/s.
0 runs, 0 assertions, 0 failures, 0 errors, 0 skips
```
Also, note that all test files will be stored inside the `test` folder.

## Addition
Let's start with addition of two field elements. First test
```
require 'test_helper'

class TestFieldAddition < Minitest::Test
  attr_reader :elem1, :elem2, :elem3, :elem4

  def setup
    @elem1 = FieldElement.new(value: 1, prime: 5)
    @elem2 = FieldElement.new(value: 2, prime: 5)
    @elem3 = FieldElement.new(value: 1, prime: 7)
    @elem4 = FieldElement.new(value: 3, prime: 5)
  end

  def test_addition
    assert_equal elem1 + elem2, elem4
    assert_equal elem4 + elem4, elem1
  end

  def test_that_raises_error
    assert_raises(TypeError) do
      elem2 + elem3
    end
  end
end
```
which will fail. So, let's implement the `FieldElement` class with addition operation.

Crate a folder `lib` and inside this folder create a file `field_element.rb`.
Our new class will have two instance variables: value and the field order to which the element belongs to.
```
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
end
```
Note that we have also defined the operators `==` and `!=` because in our test we compare class instances. I don't show here corresponding test files, but you can find them in the [project's repository](https://github.com/becaz/FFE.git).

At this point our tests should pass.

## Subtraction and negation
First tests
```
require 'test_helper'

class TestFieldSubtraction < Minitest::Test
  attr_reader :elem0, :elem1, :elem2,
              :elem3, :elem4, :invalid

  def setup
    @elem0 = FieldElement.new(value: 0, prime: 5)
    @elem1 = FieldElement.new(value: 1, prime: 5)
    @elem2 = FieldElement.new(value: 2, prime: 5)
    @elem3 = FieldElement.new(value: 3, prime: 5)
    @elem4 = FieldElement.new(value: 4, prime: 5)

    @invalid = FieldElement.new(value: 1, prime: 7)
  end

  def test_subtraction
    assert_equal elem1 - elem2, elem4
    assert_equal elem4 - elem4, elem0
    assert_equal elem4 - elem2, elem2
    assert_equal elem1 - elem0, elem1
    assert_equal elem0 - elem4, elem1
  end

  def test_negation
    assert_equal elem0 + -elem4, elem1
    assert_equal elem4 + -elem2, elem2
  end

  def test_that_raises_error
    assert_raises(TypeError) do
      invalid - elem3
    end
  end
end
```
and then implementation

```
class FieldElement
# ...

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
end
```
## Multiplication
Multiplication is also straightforward. We first perform integers multiplications and then reduce.

```
require 'test_helper'

class TestFieldMultiplication < Minitest::Test
  attr_reader :elem0, :elem1, :elem2,
              :elem3, :elem4, :invalid

  def setup
    @elem0 = FieldElement.new(value: 0, prime: 5)
    @elem1 = FieldElement.new(value: 1, prime: 5)
    @elem2 = FieldElement.new(value: 2, prime: 5)
    @elem3 = FieldElement.new(value: 3, prime: 5)
    @elem4 = FieldElement.new(value: 4, prime: 5)

    @elem = FieldElement.new(value: 1, prime: 7)
  end

  def test_multiplication
    assert_equal elem1 * elem2, elem2
    assert_equal elem4 * elem4, elem1
    assert_equal elem2 * elem4, elem3
    assert_equal elem0 * elem4, elem0
  end

  def test_multiplication_by_scalar
    assert_equal 1*elem3, elem3
    assert_equal 2*elem1, elem2
    assert_equal 3*elem4, elem2
    assert_equal 6*elem4, elem4
    assert_equal 0*elem2, elem0
    assert_equal 10*elem4, elem0
  end

  def test_that_raises_error
    assert_raises(TypeError) do
      invalid * elem3
    end
  end
end
```

We also add the `coerce` method because we implement multiplication by a scalar. For example, adding an element *a* to itself 5 times could be written as *5a*.  
```
class FieldElement
# ...

  def * other
    if other.is_a? Integer
      return FieldElement.new(prime: prime, value: (value * other) % prime)
    elsif prime == other.prime
      return FieldElement.new(prime: prime, value: (value * other.value) % prime)
    else
      raise TypeError, 'Cannot multiply two elements in different fields'
    end
  end

  def coerce other
    return self, other
  end
end
```  

## Exponentiation
For *a* in *Fp* and a positive exponent *e*, we will the use binary exponentiation algorithm to compute *a*<sup>*e*</sup>. We also use the fact that nonzero elements of a prime field form a cyclic group and for any element *c* of the group, *c*<sup>*p*-1</sup> = 1. In other words, *a*<sup>*e*</sup> = *a*<sup>*r*</sup>, where *r* is the remainder of division of *e* by *p*-1. This trick allows us to compute exponentiation to a negative power, in particular computation *a*<sup>-1</sup>, which is the inverse of *a*.


First tests,

```
require 'test_helper'

class TestFieldExp < Minitest::Test
  attr_reader :elem0, :elem1, :elem2,
              :elem3, :elem4

  def setup
    @elem0 = FieldElement.new(value: 0, prime: 5)
    @elem1 = FieldElement.new(value: 1, prime: 5)
    @elem2 = FieldElement.new(value: 2, prime: 5)
    @elem3 = FieldElement.new(value: 3, prime: 5)
    @elem4 = FieldElement.new(value: 4, prime: 5)
  end

  def test_positive_exponention
    assert_equal elem2**1, elem2
    assert_equal elem2**3, elem3
    assert_equal elem2**0, elem1
    assert_equal elem0**2, elem0
    assert_equal elem3**4, elem1
  end

  def test_negative_exponention
    assert_equal elem2**(-1), elem3
    assert_equal elem2**(-3), elem2
    assert_equal elem0**(-2), elem0
    assert_equal elem3**(-4), elem1
    assert_equal elem4**(-3), elem4
  end

  def test_that_raises_error
    assert_raises(ArgumentError) { elem0**0 }
  end
end
```

then implementation
```
class FieldElement
# ...

  def ** exp
    if value == 0 && exp == 0
      raise ArgumentError, 'Cannot raise 0 to 0'
    else
      k = exp % (prime - 1)
      return FieldElement.new(prime: prime,
                              value: modexp(value, k, prime))
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
```

## Division
Finally we implement division operation, i.e, *a/b*, which is equivalent to *a*<i>b</i><sup>-1</sup> in the prime field.

```
require 'test_helper'

class TestFieldDivision < Minitest::Test
  attr_reader :elem0, :elem1, :elem2,
              :elem3, :elem4, :elem

  def setup
    @elem0 = FieldElement.new(value: 0, prime: 5)
    @elem1 = FieldElement.new(value: 1, prime: 5)
    @elem2 = FieldElement.new(value: 2, prime: 5)
    @elem3 = FieldElement.new(value: 3, prime: 5)
    @elem4 = FieldElement.new(value: 4, prime: 5)

    @elem = FieldElement.new(value: 1, prime: 7)
  end

  def test_division
    assert_equal elem1 / elem2, elem3
    assert_equal elem4 / elem4, elem1
    assert_equal elem2 / elem4, elem3
    assert_equal elem0 / elem4, elem0
    assert_equal elem3 / elem1, elem3
  end

  def test_that_raises_error
    assert_raises(TypeError) do
      elem / elem3
    end

    assert_raises(ZeroDivisionError) do
      elem2 / elem0
    end
  end
end
```

Implementation is straightforward

```
class FieldElement
# ...

  def zero?
    value == 0
  end

  def / other
    if other.value == 0
      raise ZeroDivisionError, 'Cannot compute multiplicative inverse of 0'
    else
      self * other**(-1)
    end
  end

# ...
end
```

## Tryout
Let's play around with our class. Let's consider the prime field *F*<sub>7</sub>.

`require_relative 'lib/field_element'`

`a = FieldElement.new(value: 3, prime: 7)`

`puts 3*a # => FE7(2)`

`puts a**-3 # => FE7(6)`

`b = FieldElement.new(value: 5, prime: 7)`

`puts a*b # => FE7(1)`
