
require 'test_helper'

class TestFieldElement < Minitest::Test
  attr_reader :elem1, :elem2, :elem3, :elem4, :elem5

  def setup
    @elem1 = FieldElement.new(value: 1, prime: 5)
    @elem2 = FieldElement.new(value: 2, prime: 5)
    @elem3 = FieldElement.new(value: 1, prime: 7)
    @elem4 = FieldElement.new(value: 1, prime: 5)
    @elem5 = FieldElement.new(value: 3, prime: 5)
  end

  def test_that_it_raises_exception
    assert_raises(ArgumentError) do
      FieldElement.new(value: 5, prime: 5)
    end

    assert_raises(ArgumentError) do
      FieldElement.new(value: -1, prime: 5)
    end

    assert_raises(ArgumentError) do
      FieldElement.new(value: 6, prime: 5)
    end
  end

  def test_that_elements_equal
    assert_equal elem1, elem1
    assert_equal elem1, elem4
  end

  def test_that_elements_not_equal
    refute_equal elem1, elem2
    refute_equal elem1, elem3
  end

  def test_that_it_converts_to_string
    assert_equal elem1.to_s, 'FE5(1)'
  end

end
