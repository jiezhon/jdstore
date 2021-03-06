class CartsController < ApplicationController
  def index
    if current_cart.present? && current_cart.chef_id != nil
      @chef = Chef.find(current_cart.chef_id)
    end
  end

  def clean
    current_cart.clean!
    current_cart.chef_id = nil
    current_cart.book_date = nil
    current_cart.save
    flash[:warning] = "已清空购物车"
    redirect_to carts_path
  end

  def checkout
    @chef = Chef.find(current_cart.chef_id)
    @order = Order.new

  end

  def update
    @cart = Cart.find(params[:id])
    @cart.update(cart_params)

    if params[:product_id].present?
      @product = Product.find(params[:product_id])
    end
    redirect_to :back
  end

  private
  def cart_params
    params.require(:cart).permit(:book_date)
  end
end
