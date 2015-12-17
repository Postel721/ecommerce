class CartController < ApplicationController

	before_filter :authenticate_user!, except: [:add_to_cart, :view_order]

  def add_to_cart
    product = Product.find(params[:product_id])
    if product.quantity < params[:quantity].to_i
      redirect_to product, notice: 'Not enough stock available to complete order.'
    else
  	line_item = LineItem.new
  	line_item.product_id = params[:product_id]
  	line_item.quantity = params[:quantity]
  	line_item.save

  	line_item.line_item_total = line_item.product.price * line_item.quantity
  	line_item.save

  	redirect_to root_path
    end
  end

  def by_category
    line_item = LineItem.new
    line_item.product_id = params[:product_id]
    line_item.quantity = params[:quantity]
    line_item.save

    line_item.line_item_total = line_item.product.price * line_item.quantity
    line_item.save

    redirect_to root_path
  end

  def by_brand
    line_item = LineItem.new
    line_item.product_id = params[:product_id]
    line_item.quantity = params[:quantity]
    line_item.save

    line_item.line_item_total = line_item.product.price * line_item.quantity
    line_item.save

    redirect_to root_path
  end

  def view_order
  	@line_items = LineItem.all
  end
  
  def order_complete
    @order = Order.find(params[:order_id])
    @amount = (@order.grand_total.to_f.round(2) * 100).to_i

    customer = Stripe::Customer.create(
      :email => current_user.email,
      :card => params[:stripeToken]
    )

    charge = Stripe::Charge.create(
      :customer => customer.id,
      :amount => @amount,
      :description => 'Rails Stripe customer',
      :currency => 'usd'
    )

    rescue Stripe::CardError => e
    flash[:error] = e.message
    redirect_to charges_path
  end

  def remove_from_cart
    LineItem.find(params[:id]).destroy
    redirect_to view_order_path
  end

  def edit_list_item
    x = LineItem.find(params[:id])
    x.quantity = params[:qty]
    x.total = x.quantity * x.product.price
    x.save

    redirect_to view_order_path
  end 
  
  def checkout
  	@line_items = LineItem.all
  	@order = Order.new
  	@order.user_id = current_user.id

  	sum = 0  

  	@line_items.each do |lineitem|
  		@order.order_items[lineitem.product_id] = lineitem.quantity
  		sum += lineitem.line_item_total
  	end 

  	@order.subtotal = sum
  	@order.sales_tax = sum * 0.07
  	@order.grand_total = sum + @order.sales_tax
  	@order.save 

  	@line_items.each do |lineitem|
  		lineitem.product.quantity -= lineitem.quantity
  		lineitem.product.save
  	end

  	LineItem.destroy_all
  	
  end
end