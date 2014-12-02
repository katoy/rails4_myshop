# coding: utf-8

require 'rails_helper.rb'

describe "init-category" do

  include ActionView::Helpers

  before(:all) do
    create(:root_category)
  end

  specify "init" do

    root = Category.where(name: 'root').first
    expect(root.to_hash).to eq({
                                 :code=>"0", :name=>"root", :child=>[
                                   {:code=>"1", :name=>"book", :child=>[
                                      {:code=>"1.1", :name=>"book_1", :child=>[
                                         {:code=>"1.1.1", :name=>"book_1_1"},
                                         {:code=>"1.1.2", :name=>"book_1_2"}]
                                      },
                                      {:code=>"1.2", :name=>"book_2", :child=>[
                                         {:code=>"1.2.1", :name=>"book_2_1"},
                                         {:code=>"1.2.2", :name=>"book_2_2"}]
                                      }]
                                   }]
                               })

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

  specify 'category2text' do

    root = Category.where(name: 'root').first

    str = root.category2tree
    expect(str).to eq(<<EOS)
0 root
  1 book
    1.1 book_1
      1.1.1 book_1_1
      1.1.2 book_1_2
    1.2 book_2
      1.2.1 book_2_1
      1.2.2 book_2_2
EOS
  end
end
