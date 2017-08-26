require 'test_helper'
class CreateCategoriesTest < ActionDispatch::IntegrationTest
  test 'get new category form and crete category' do
    get new_category_path
    assert_templeate 'categories/new'
    assert_difference 'Category.count',1 do
      post_via_redirect cotegories_path, category: {name:'Sports'}
    end
  assert_templeate 'categories/index'
  assert_match 'Sports',response.body
  end
end
