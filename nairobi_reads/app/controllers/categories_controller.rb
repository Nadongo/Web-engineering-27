class CategoriesController < ApplicationController
  before_action :require_admin, only: [:create, :destroy]

  def create
    @category = Category.new(category_params)
    if @category.save
      flash[:success] = "Category '#{@category.name}' created!"
    else
      flash[:error] = "Failed to create category."
    end
    redirect_to admin_dashboard_path(tab: 'categories')
  end

  def destroy
    @category = Category.find(params[:id])
    # Professional Safety Check: Don't delete if books are attached
    if @category.books.any?
      flash[:error] = "Cannot delete category '#{@category.name}' because it contains books."
    else
      @category.destroy
      flash[:success] = "Category deleted."
    end
    redirect_to admin_dashboard_path(tab: 'categories')
  end

  private

  def category_params
    params.require(:category).permit(:name)
  end
end