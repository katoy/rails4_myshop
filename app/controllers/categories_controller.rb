class CategoriesController < ApplicationController
  before_action :set_category, only: [:show, :edit, :update, :destroy]

  # GET /categories
  # GET /categories.json
  def index
    @categories = Category.all
  end

  def tree
    @categories = Category.all
  end

  def treeData
    data = generate_category_tree(Category.find(1))
    data = data[:children]
    respond_to do |format|
      format.json { render json: data }
    end
  end

  # GET /categories/1
  # GET /categories/1.json
  def show
  end

  # GET /categories/new
  def new
    @category = Category.new
  end

  # GET /categories/1
  def show
    @category = Category.where(id: params['id']).first
    @parents = get_parents(@category)
  end

  # GET /categories/1/edit
  def edit
  end

  # POST /categories
  # POST /categories.json
  def create
    @category = Category.new(category_params)

    respond_to do |format|
      if @category.save
        format.html { redirect_to @category, notice: 'Category was successfully created.' }
        format.json { render :show, status: :created, location: @category }
      else
        format.html { render :new }
        format.json { render json: @category.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /categories/1
  # PATCH/PUT /categories/1.json
  def update
    respond_to do |format|
      if @category.update(category_params)
        format.html { redirect_to @category, notice: 'Category was successfully updated.' }
        format.json { render :show, status: :ok, location: @category }
      else
        format.html { render :edit }
        format.json { render json: @category.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /categories/1
  # DELETE /categories/1.json
  def destroy
    @category.destroy
    respond_to do |format|
      format.html { redirect_to categories_url, notice: 'Category was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  # get /categories/list
  def list
    selected_category = Category.where(code: list_params).first
    childs = selected_category.childs.sort{|a, b| a.code <=> b.code}
    data = []
    childs.each do |child|
      data << {code: child.code, name: child.name}
    end
    respond_to do |format|
      format.json { render json: data }
    end
  end

  def select
    root = Category.find(1)
    @categories = root.childs.sort{|a, b| a.code <=> b.code}
    @childs = @categories[0].childs.sort{|a, b| a.code <=> b.code}
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_category
    @category = Category.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def category_params
    params.require(:category).permit(:code, :name, :parent_id)
  end

  def list_params
    params.require(:code)
  end

  def get_parents(category)
    ans = []
    cp = category
    while cp.id != 1
      cp = Category.where(id: cp.parent_id).first
      ans << cp
    end
    ans.reverse!
  end

  def generate_category_tree(category)
    ans = {}
    root = Category.find(1)
    cp = category
    childs = cp.childs
    if childs == nil || childs.size == 0
      ans = {id: cp.id, text: cp.name, code: cp.code, type: 'file'}
    else
      child_ary = []
      childs.sort{|a, b| a.code <=> b.code}.each do |c|
        child_ary << generate_category_tree(c)
      end
      ans = {id: cp.id, text: cp.name, code: cp.code, type: 'folder', children: child_ary }
    end
    ans
  end
end
