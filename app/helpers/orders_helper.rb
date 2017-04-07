module OrdersHelper
  def render_order_created_time(order)
    order.created_at.to_s(:shor)
  end

  def render_order_status(order_staus)
     status = case order_staus
       when "order_placed"
        "订单已提交"
       when "paid"
        "已支付"
       when "shipping"
        "已出货"
       when "shipped"
        "已到货"
       when "order_cancelled"
        "订单已取消"
       when "good_returned"
        "已退货"
     end
  end

  def render_order_action(order_staus)
     case order_staus
       when "order_placed"
         link_to("取消订单", cancel_admin_order_path(order),
                  class: "btn btn-default btn-sm", method: :post)
       when "paid"
         link_to("取消订单", cancel_admin_order_path(order),
                    class: "btn btn-default btn-sm", method: :post)
         link_to("出货", ship_admin_order_path(order),
                    class: "btn btn-default btn-sm", method: :post)
       when "shipping"
         link_to("设为已出货", shipped_admin_order_path(order),
                    class: "btn btn-default btn-sm", method: :post)
       when "shipped"
         link_to("退货", return_admin_order_path(order),
                    class: "btn btn-default btn-sm", method: :post)
       when "order_cancelled"
        content_tag(:span, "订单已取消", :class => "label label-default")
       when "good_returned"
        content_tag(:span, "已退货", :class => "label label-default")
     end
  end

end
