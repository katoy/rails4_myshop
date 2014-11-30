
ActiveRecord で nest した Category 構造を作る例です。  

    $ rails rails _4.1.8_ new rails4_myshop -T
    $ cd rails4_myshop

    $ rails g scaffold Category name:string parent_id:integer
	$ rails g scaffold Item name:string category_id:integer
	$ rake db.migrate

    $ rm test.sqlite3
    $ rspec spec/sample.rb
    root		
      本		
        book_1		
          book_1_1		
            book_1_1_1		
            book_1_1_2		["item_1", "item_2"]
          book_1_2		
            book_1_2_1		
            book_1_2_2		
        book_2		["item_3"]
    Finished in 0.0736 seconds (files took 2.77 seconds to load)
    1 example, 0 failures

spec/sample.rb の中で、 Category の階層を構築し、item に category を設定しています。
そして、Category の階層構造を stdout に出力しています。  

rspec を実行した後に、
rails c で DB の内容を確認したり、 Category の改装をたどったりしてみます。

    $ rails c -e test

Category の DB 内容を確認する。  

    pry(main)> Category.all
    +----+------------+-----------+-------------------------+-------------------------+
    | id | name       | parent_id | created_at              | updated_at              |
    +----+------------+-----------+-------------------------+-------------------------+
    | 1  | root       |           | 2014-11-29 09:50:38 UTC | 2014-11-29 09:50:38 UTC |
    | 2  | 本         | 1         | 2014-11-29 09:50:38 UTC | 2014-11-29 09:50:38 UTC |
    | 3  | book_1     | 2         | 2014-11-29 09:50:38 UTC | 2014-11-29 09:50:38 UTC |
    | 4  | book_1_1   | 3         | 2014-11-29 09:50:38 UTC | 2014-11-29 09:50:38 UTC |
    | 5  | book_1_1_1 | 4         | 2014-11-29 09:50:38 UTC | 2014-11-29 09:50:38 UTC |
    | 6  | book_1_1_2 | 4         | 2014-11-29 09:50:38 UTC | 2014-11-29 09:50:38 UTC |
    | 7  | book_1_2   | 3         | 2014-11-29 09:50:38 UTC | 2014-11-29 09:50:38 UTC |
    | 8  | book_1_2_1 | 7         | 2014-11-29 09:50:38 UTC | 2014-11-29 09:50:38 UTC |
    | 9  | book_1_2_2 | 7         | 2014-11-29 09:50:38 UTC | 2014-11-29 09:50:38 UTC |
    | 10 | book_2     | 2         | 2014-11-29 09:50:38 UTC | 2014-11-29 09:50:38 UTC |
    +----+------------+-----------+-------------------------+-------------------------+

Item の DB 内容を確認する。  

    pry(main)> Item.all
    +----+--------+-------------+-------------------------+-------------------------+
    | id | name   | category_id | created_at              | updated_at              |
    +----+--------+-------------+-------------------------+-------------------------+
    | 1  | item_1 | 6           | 2014-11-29 09:50:38 UTC | 2014-11-29 09:50:38 UTC |
    | 2  | item_2 | 6           | 2014-11-29 09:50:38 UTC | 2014-11-29 09:50:38 UTC |
    | 3  | item_3 | 10          | 2014-11-29 09:50:38 UTC | 2014-11-29 09:50:38 UTC |
    +----+--------+-------------+-------------------------+-------------------------+

カテゴリーの階層をたどってみる。  

    pry(main)> root = Category.where(name: 'root').first
    +----+------+-----------+-------------------------+-------------------------+
    | id | name | parent_id | created_at              | updated_at              |
    +----+------+-----------+-------------------------+-------------------------+
    | 1  | root |           | 2014-11-29 09:50:38 UTC | 2014-11-29 09:50:38 UTC |
    +----+------+-----------+-------------------------+-------------------------+

    pry(main)> root.childs
    +----+------+-----------+-------------------------+-------------------------+
    | id | name | parent_id | created_at              | updated_at              |
    +----+------+-----------+-------------------------+-------------------------+
    | 2  | 本   | 1         | 2014-11-29 09:50:38 UTC | 2014-11-29 09:50:38 UTC |
    +----+------+-----------+-------------------------+-------------------------+

    pry(main)> root.childs[0].childs
    +----+--------+-----------+-------------------------+-------------------------+
    | id | name   | parent_id | created_at              | updated_at              |
    +----+--------+-----------+-------------------------+-------------------------+
    | 3  | book_1 | 2         | 2014-11-29 09:50:38 UTC | 2014-11-29 09:50:38 UTC |
    | 10 | book_2 | 2         | 2014-11-29 09:50:38 UTC | 2014-11-29 09:50:38 UTC |
    +----+--------+-----------+-------------------------+-------------------------+

カテゴリーに属する item を確認する。  

    pry(main)> root.childs[0].childs[1].items
    +----+--------+-------------+-------------------------+-------------------------+
    | id | name   | category_id | created_at              | updated_at              |
    +----+--------+-------------+-------------------------+-------------------------+
    | 3  | item_3 | 10          | 2014-11-29 09:50:38 UTC | 2014-11-29 09:50:38 UTC |
    +----+--------+-------------+-------------------------+-------------------------+

irem が属するカテゴリーを確認する。  

    pry(main)> root.childs[0].childs[1].items[0].category
    +----+--------+-----------+-------------------------+-------------------------+
    | id | name   | parent_id | created_at              | updated_at              |
    +----+--------+-----------+-------------------------+-------------------------+
    | 10 | book_2 | 2         | 2014-11-29 09:50:38 UTC | 2014-11-29 09:50:38 UTC |
    +----+--------+-----------+-------------------------+-------------------------+


Factorygirl + rspec

    $ bundle exec rake test:prepare
    $ bundle exec rspec

DB の設定

    $ bundle exec rake db:seed
    $ rails c

TODO

- jstree をつかって category の tree 表示、編集 を web 画面からできるようにする事。


参考：
- [Ruby on Railsで同一モデルでhas_many,belongs_toを実現する](http://web.sfc.keio.ac.jp/~t11240rk/blog/?p=242)

- [teratail Rails 無限階層カテゴリの実装](https://teratail.com/questions/3765)
- [Rails 4.1.6 カテゴリーをツリー構造](https://teratail.com/questions/3811)
