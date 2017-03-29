class Admin::OrdersController < AdminController
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
    @chef = ChefShadow.find_by(order_id: @order.id)
    @order.ship!
    OrderMailer.notify_ship(@order, @chef).deliver!
    redirect_to :back
  end

  def shipped
    @order.deliver!
    redirect_to :back
  end

  def cancel
    @chef = ChefShadow.find_by(order_id: @order.id)
    @order.cancell_order!
    OrderMailer.notify_cancel(@order, @chef).deliver!
    redirect_to :back
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
