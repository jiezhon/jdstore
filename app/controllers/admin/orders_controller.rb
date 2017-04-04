class Admin::OrdersController < AdminController
  include Util
  before_action :find_order, only: [:show, :ship, :shipped, :cancel, :return]

  def index
    @orders = Order.order("id DESC")
    @orders = @orders.paginate(:page => params[:page], :per_page => 10)
  end

  def show
    @chef_shadow = ChefShadow.find_by(order_id: @order.id)
    @product_lists = @order.product_lists
  end

  def ship
    admin_do ("ship")
  end

  def shipped
    @order.deliver!
    redirect_to :back
  end

  def cancel
    admin_do ("cancel")
  end

  def return
    @order.return_good!
    redirect_to :back
  end

  private
  def find_order
    @order = Order.find(params[:id])
  end

end
