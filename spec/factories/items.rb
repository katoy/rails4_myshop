FactoryGirl.define do
  factory :item_1_1_A, class: Item do |item|
    item.code '1.1.1'
    item.name 'item_1_1_A'
  end

  factory :item_1_2_A, class: Item do |item|
    item.code '1.2.A'
    item.name 'item_1_2_A'
  end

  factory :item_1_2_B, class: Item do |item|
    item.code '1.2.B'
    item.name 'item_1_2_B'
  end

end
