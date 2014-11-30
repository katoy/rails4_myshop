# coding: utf-8
class Category < ActiveRecord::Base
  # belongs_to :parent, class_name: 'Category', foreign_key: 'parent_id'
  has_many   :childs, class_name: 'Category', foreign_key: 'parent_id'
  has_many   :items

  # category の tree 構造を nest した Hash {od: *, name: *, chikd: *} にする。
  def to_hash
    ans = {name: name}
    ans[:child] = childs.map{|c| c.to_hash} if childs && childs.size > 0
    ans
  end

  def get_all_items
    ans = []
    ans = items.map{|x| x.name} if items && items.size > 0
    childs.each{|c| ans += c.get_all_items} if childs && childs.size > 0
    ans
  end
end
