class ProductsController < ApplicationController
  before_action :authenticate_user!, only: [:add_to_cart]
  before_action :find_product, only: [:show, :add_to_cart, :follow_dish, :unfollow_dish]

  def index
    @products = Product.published.where.not(:id => 1) #1 is a dummy product
    @chef = Chef.find(current_cart.chef_id)
    @products = @products.where(style: @chef.style)

  end

  def show
    @photos = @product.photos.all

    set_page_title @product.title
    set_page_description "#{@product.description}"
  end

  def add_to_cart
    if !current_cart.products.include?(@product)
      current_cart.add_product_to_cart(@product)
      flash[:notice] = "你已成功将 #{@product.title} 加入购物车"
    else
      flash[:warning] = "你的购物车内已有此物品"
    end

    #redirect_to products_path
  end

  def follow_dish
    current_user.follow_dish!(@product)

    #redirect_to :back
  end

  def unfollow_dish
    current_user.unfollow_dish!(@product)

    #redirect_to :back
    render "follow_dish"
  end

  private

  def find_product
    # @product = Product.find(params[:id])
    @product = Product.find_by_friendly_id(params[:id])
  end

end
