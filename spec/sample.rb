# coding: utf-8

require 'rails_helper.rb'

def setup
  # 次の Category 構造を作る。
  # root
  #   |-- 本
  #       |-- book_1
  #       |     |-- book_1_1
  #       |     | |-- book_1_1_1
  #       |     |  |-- book_1_1_2    [item_1, item_2]
  #       |     |-- book_1_2
  #       |       |-- book_1_2_1
  #       |       |-- book_1_2_2
  #       |-- book_2                 [iten_3]

  root = Category.where(name: 'root').first_or_create
  book = Category.where(name: '本').first_or_create

  book_1     = Category.where(name: 'book_1').first_or_create
  book_1_1   = Category.where(name: 'book_1_1').first_or_create
  book_1_1_1 = Category.where(name: 'book_1_1_1').first_or_create
  book_1_1_2 = Category.where(name: 'book_1_1_2').first_or_create
  book_1_2   = Category.where(name: 'book_1_2').first_or_create
  book_1_2_1 = Category.where(name: 'book_1_2_1').first_or_create
  book_1_2_2 = Category.where(name: 'book_1_2_2').first_or_create

  book_2     = Category.where(name: 'book_2').first_or_create

  root.childs = [book]
  root.save!

  book.childs = [book_1, book_2]
  book.save!

  book_1.childs = [book_1_1, book_1_2]
  book_1_1.childs = [book_1_1_1, book_1_1_2]
  book_1_2.childs = [book_1_2_1, book_1_2_2]

  book_1.save!
  book_1_1.save!
  book_1_1_1.save!
  book_1_1_2.save!
  book_1_2.save!
  book_1_2_1.save!
  book_1_2_2.save!

  # item を 設定する
  item_1 = Item.where(name: 'item_1').first_or_create
  item_2 = Item.where(name: 'item_2').first_or_create
  item_3 = Item.where(name: 'item_3').first_or_create
  book_1_1_2.items = [item_1, item_2]
  book_2.items = [item_3]
end

# category を tree 表示する。
def show_tree(root, level = 0)
  item_name = ''
  if root.items.size > 0
    item_names = root.items.map{|x| x.name}.to_s
  end
  puts "#{'  ' * level}#{root.name}\t\t#{item_names}"
  root.childs.each do |c|
    show_tree(c, level + 1)
  end
end

# category 以下のすべての item を得る
def get_all_items(root)
  ans = root.items
  root.childs.each do |child|
    ans += get_all_items(child)
  end
  ans
end

describe "sample" do
  specify "sample" do
    setup
    root = Category.where(name: 'root').first
    show_tree(root)

    item_1 = Item.where(name: 'item_1').first
    expect(item_1.category.name).to eq('book_1_1_2')

    item_2 = Item.where(name: 'item_2').first
    expect(item_2.category.name).to eq('book_1_1_2')

    item_3 = Item.where(name: 'item_3').first
    expect(item_3.category.name).to eq('book_2')

    items = get_all_items(root).map{|x| x.name}.sort
    expect(items).to eq(['item_1', 'item_2', 'item_3'])

    book_2 = Category.where(name: 'book_2').first
    items = get_all_items(book_2).map{|x| x.name}
    expect(items).to eq(['item_3'])
  end
end
