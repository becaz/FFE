
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
