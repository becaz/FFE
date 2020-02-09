# frozen_string_literal: true

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
