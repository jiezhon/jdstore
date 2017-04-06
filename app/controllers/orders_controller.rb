class OrdersController < ApplicationController
  include Util

  before_action :authenticate_user!, only: [:create]
  before_action :find_order, only: [:apply_to_cancel, :apply_to_return]
  before_action :find_order_by_token, only: [:pay_with_wechat, :pay_with_alipay]

  def create
    @order = Order.new(order_params)
    @order.user = current_user
    @order.total = current_cart.total_price
    @order.book_date = current_cart.book_date

    if @order.save
      current_cart.cart_items.each do |cart_item|
        if !cart_item.product.is_hidden
        product_list = ProductList.new
        product_list.order = @order
        product_list.produt_name = cart_item.product.title
        product_list.product_price = cart_item.product.price
        product_list.quantity = cart_item.quantity
        product_list.style = cart_item.product.style
        product_list.save

        product = cart_item.product
        origin_quantity = product.quantity
        product.quantity = origin_quantity - cart_item.quantity
        product.save
        end
      end

      chef = Chef.find(current_cart.chef_id)
      @chef_shadow = ChefShadow.new
      @chef_shadow.order = @order
      @chef_shadow.name = chef.name
      @chef_shadow.chef_level_id = chef.chef_level_id
      @chef_shadow.style = chef.style
      @chef_shadow.phone = chef.phone
      @chef_shadow.save

      #clean current cart
      current_cart.chef_id = nil
      current_cart.book_date = nil
      current_cart.save
      current_cart.clean!

      OrderMailer.notify_status(@order, @chef_shadow, "order_placed").deliver!
      redirect_to order_path(@order.token)
    else
      render 'carts/checkout'
    end
  end

  def show
    @order = current_user.orders.find_by_token(params[:id])
    @product_lists = @order.product_lists
    @chef_shadow = ChefShadow.find_by(order_id: @order.id)
  end

  def pay_with_alipay
    pay_with("alipay")
  end

  def pay_with_wechat
    pay_with("wechat")
  end

  def apply_to_cancel
    apply_to("cancel")
  end

  def apply_to_return
    apply_to("return")
  end

  private
  def order_params
    params.require(:order).permit(:billing_name, :billing_address, :shipping_name, :shipping_address)
  end

  def find_order
    @order = Order.find(params[:id])
  end

  def find_order_by_token
    @order = Order.find_by_token(params[:id])
  end

end
