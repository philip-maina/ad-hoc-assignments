require_relative "test_helper.rb"

class CalculatorTest < Minitest::Test
  def setup
    @calculator = SLCSP::Calculator.new
    @calculator.calculate
  end

  # happy path
  # ✓ Zipcode 64148: [234.6, 245.2, 251.08, 253.65, 265.25, 265.82, 271.64, 290.05, 298.87, 312.06, 319.57, 341.24, 351.6]
  def test_correct_slcsp
    assert_equal "245.20", @calculator.calculations.find { |calc| calc.zipcode == "64148" }.rate
  end

  # ✓ Zipcode 52654: [230.29, 230.29, 242.39, 242.39, 278.29, 291.6, 335.56]           
  def test_correct_slcsp_for_duplicate_rates
    assert_equal "242.39", @calculator.calculations.find { |calc| calc.zipcode == "52654" }.rate
  end

  # ✓ Zipcode 31551: [99.53, 290.6, 296.75, 306.07, 333.06, 335.81, 344.01, 354.59, 362.92, 364.99, 368.31, 373.49, 464.35, 476.93]
  #                  Output should be 290.60 not 290.6
  def test_correct_slcsp_format
    assert_equal "290.60", @calculator.calculations.find { |calc| calc.zipcode == "31551" }.rate
  end

  # ✓ Zipcode 40813 maps to (KY, 8) which has no plans hence no rates
  # ✓ Zipcode 07184 maps to (NJ, 1) which only has one silver plan with rate - 262.65
  def test_slcsp_doesnt_exist
    assert_nil @calculator.calculations.find { |calc| calc.zipcode == "40813" }.rate
    assert_nil @calculator.calculations.find { |calc| calc.zipcode == "07184" }.rate
  end

  # ✓ Zipcode 54923 maps to more than one rate area [(WI, 11), (WI, 15)] 
  def test_slcsp_doesnt_exist_for_ambiguous_zip_codes
    assert_nil @calculator.calculations.find { |calc| calc.zipcode == "54923" }.rate
  end
end