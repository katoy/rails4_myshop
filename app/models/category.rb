class Category < ActiveRecord::Base
  # belongs_to :parent, class_name: 'Category', foreign_key: 'parent_id'
  has_many   :childs, class_name: 'Category', foreign_key: 'parent_id'
  has_many   :items
end
