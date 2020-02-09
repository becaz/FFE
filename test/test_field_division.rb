# frozen_string_literal: true

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
