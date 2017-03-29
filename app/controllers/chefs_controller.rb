class ChefsController < ApplicationController
  before_action :authenticate_user!, only: [:add_to_cart]
  before_action :find_chef, only: [:show, :follow, :unfollow]
  def index
    @chefs = Chef.includes(:photos).published

    if params[:city].present?
      @city = params[:city]
      @chefs = @chefs.where(city: params[:city])
    end
    if params[:style].present?
      @style = params[:style]
      @chefs = @chefs.where(style: params[:style])
    end
    if params[:product_id].present?
      @product = Product.find(params[:product_id])
    end

    if params[:order].present?

    @chefs = case params[:order]
            when 'by_followers'
              @chefs.sort_by{|chef| chef.followers.count}.reverse
            when 'by_level'
              @chefs.order("chef_level_id")
            else
              @chefs.recent
            end
    end

  end

  def show
    @photos = @chef.photos.all
    if current_cart.chef_id != nil
      @current_chef_in_cart = Chef.find(current_cart.chef_id)
      if @chef.id != current_cart.chef_id
        if @chef.style != @current_chef_in_cart.style
          flash[:warning] = "您当前选择的厨师 #{@current_chef_in_cart.name} 擅长的菜系是#{@current_chef_in_cart.style}， 如果更换其他菜系厨师需要重新选择菜品！"
        else
          flash[:warning] = "您当前选择的厨师 #{@current_chef_in_cart.name}"
        end
      end
    end
    if params[:product_id].present?
      @product = Product.find(params[:product_id])
    end
    @chef_comments = ChefComment.where(chef_id: @chef.id).order("created_at DESC")
    @chef_comment = ChefComment.new
  end

  def add_to_cart
    if current_cart.book_date == nil
      flash[:warning] = "请先选择预定日期！"
      redirect_to :back
    else
        @chef = Chef.find(params[:id])
        if current_cart.chef_id != nil
          current_chef_in_cart = Chef.find(current_cart.chef_id)
          if @chef.style != current_chef_in_cart.style
            current_cart.clean!
            current_cart.chef_id = nil
            current_cart.save
            #flash[:warning] = "当前购物车已清空！请重新选择菜品！"
          end
        end
        current_cart.chef_id = @chef.id
        current_cart.save

        #Start for insert a record to chef_times
        chef_time = ChefTime.new
        chef_time.chef = @chef
        chef_time.day = current_cart.book_date.to_formatted_s(:db)
        chef_time.is_available = false
        chef_time.save
        #End

        if params[:product_id].present?
          @product = Product.find(params[:product_id])
          if !current_cart.products.include?(@product)
            current_cart.add_product_to_cart(@product)
          end
          flash[:notice] = "为您推荐厨师#{@chef.name}的其他菜品。"
        end
        redirect_to products_path
    end
  end

  def follow
    current_user.follow!(@chef)

    redirect_to :back
  end

  def unfollow
    current_user.unfollow!(@chef)

    #flash[:warning] = "Stop follow!"
    redirect_to :back
  end

  private
  def find_chef
    @chef = Chef.find(params[:id])
  end
end
