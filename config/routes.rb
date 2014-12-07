Rails.application.routes.draw do

  root :to => 'categories#index'

  resources :items

  get 'categories/tree'     => 'categories#tree'
  get 'categories/treeData' => 'categories#treeData'
  get 'categories/select'   => 'categories#select'
  get 'categories/:id/list' => 'categories#list'
  resources :categories


end
