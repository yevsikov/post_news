require 'test_helper'

class OptionTest < ActiveSupport::TestCase
  test "should_set_option_value" do
    Option.set_value('num', 42)
    @option = Option.find_by_name('num')

    assert_equal @option.value.to_i, 42
  end

  test "should_create_only_one_option_with_uniq_name" do
    Option.set_value('num', 42)
    Option.set_value('num', 43)
    @option = Option.find_by_name('num')

    assert_equal @option.value.to_i, 43
    assert_equal Option.all.count, 1
  end

  test "should_return_actual_option_value" do
    Option.set_value('num', 42)
    option = Option.get_value('num')

    assert_equal option.to_i, 42
  end

  test "should_not_fail_on_returning_option_value" do
    option = Option.get_value('num')

    assert_nil option
  end
end
