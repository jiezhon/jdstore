module OrdersHelper
  def render_order_created_time(order)
    order.created_at.to_s(:shor)
  end
end
