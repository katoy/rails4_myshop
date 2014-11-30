# coding: utf-8

require 'rails_helper.rb'

describe "init-category" do
  specify "init" do
    create(:root_category)

    root = Category.where(name: 'root').first
    expect(root.to_hash).to eq({:name=>"root", :child=>[
                                  {:name=>"book", :child=>[
                                     {:name=>"book_1", :child=>[
                                        {:name=>"book_1_1"},
                                        {:name=>"book_1_2"}]},
                                     {:name=>"book_2", :child=>[
                                        {:name=>"book_2_1"},
                                        {:name=>"book_2_2"}]}]}]}
                              )

    expect(root.get_all_items).to eq(['item_1_1_A', 'item_1_2_A', 'item_1_2_B'])

    book_1_1 = root.childs[0].childs[0].childs[0]
    expect(book_1_1.name).to eq('book_1_1')
    expect(book_1_1.get_all_items).to eq(['item_1_1_A'])

    book_1_2 = root.childs[0].childs[0].childs[1]
    expect(book_1_2.name).to eq('book_1_2')
    expect(book_1_2.get_all_items).to eq(['item_1_2_A', 'item_1_2_B'])

    item_1_1_A = Item.where(name: 'item_1_1_A').first
    expect(item_1_1_A.category.name).to eq('book_1_1')

    item_1_2_A = Item.where(name: 'item_1_2_A').first
    expect(item_1_2_A.category.name).to eq('book_1_2')

    item_1_2_B = Item.where(name: 'item_1_2_B').first
    expect(item_1_2_B.category.name).to eq('book_1_2')
  end
end
