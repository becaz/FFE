# frozen_string_literal: true

require 'test_helper'

class TestFieldArithm < Minitest::Test
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

  def test_exp1
    assert_equal (elem1 - elem2)**2, elem1
  end

  def test_exp2
    assert_equal (elem4 - elem2)*elem0, elem0
  end

  def test_exp3
    assert_equal elem2 - (elem4 - elem1)*elem0, elem2
  end

  def test_exp4
    assert_equal (elem0 - elem4)**(-4), elem1
  end

  def test_exp5
    assert_equal (elem0 - elem2)**(-3) + elem4, elem2
  end
end
