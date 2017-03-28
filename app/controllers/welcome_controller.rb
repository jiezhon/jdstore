class WelcomeController < ApplicationController
  def index
    #flash[:notice] = "Good Morning"
    @chefs = Chef.includes(:photos).published.where(chef_level_id: 1)
    @products = Product.includes(:product_photos).published.specialed
  end

  def about
  end

end
