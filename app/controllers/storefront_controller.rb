class StorefrontController < ApplicationController
  def all_items
  	@products = Product.all
  end

  def items_by_category
  	@category = Category.find(params[:cat_id])
  	products = Product.all
  	@products =[]

  	products.each do |product|
  		if product.category.id == params[:cat_id].to_i
  			@products.push(product)
  		end
  	 end
  end

  def items_by_brand
    @brand = params[:brand]
    @products= Product.where(brand: @brand)
  end
end
