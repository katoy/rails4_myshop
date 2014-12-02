FactoryGirl.define do
  factory :root_category, class: Category do |category|
    category.code '0'
    category.name 'root'
    category.childs {[FactoryGirl.create(:book)]}
  end

  factory :book, class: Category do |category|
    category.code '1'
    category.name 'book'
    category.childs {[
                       FactoryGirl.create(:book_1),
                       FactoryGirl.create(:book_2),
                     ]}
  end

  factory :book_1, class: Category do |category|
    category.code '1.1'
    category.name 'book_1'
    category.childs {[
                       FactoryGirl.create(:book_1_1),
                       FactoryGirl.create(:book_1_2),
                     ]}
  end
  factory :book_1_1, class: Category do |category|
    category.code '1.1.1'
    category.name 'book_1_1'
    category.items {[FactoryGirl.create(:item_1_1_A)]}
  end
  factory :book_1_2, class: Category do |category|
    category.code '1.1.2'
    category.name 'book_1_2'
    category.items {[FactoryGirl.create(:item_1_2_A),
                     FactoryGirl.create(:item_1_2_B),
                    ]}
  end

  factory :book_2, class: Category do |category|
    category.code '1.2'
    category.name 'book_2'
    category.childs {[
                       FactoryGirl.create(:book_2_1),
                       FactoryGirl.create(:book_2_2),
                     ]}
  end
  factory :book_2_1, class: Category do |category|
    category.code '1.2.1'
    category.name 'book_2_1'
  end
  factory :book_2_2, class: Category do |category|
    category.code '1.2.2'
    category.name 'book_2_2'
  end
end
