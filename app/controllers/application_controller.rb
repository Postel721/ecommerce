class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_filter :all_categories
  before_filter :brands

  def all_categories
  	@categories = Category.all
  end

  def brands
  	@brands = []
  	products = Product.all

  	products.each do |p|
  		unless @brands.include? p.brand
  			@brands.push(p.brand)
  		end
  	end
  end
end
