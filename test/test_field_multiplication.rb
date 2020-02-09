# frozen_string_literal: true

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

    @invalid = FieldElement.new(value: 1, prime: 7)
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
