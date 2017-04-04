module Util
  def apply_to(action)
    @chef = ChefShadow.find_by(order_id: @order.id)
    if action == "cancel"
      OrderMailer.apply_return(@order, @chef).deliver!
      flash[:notice] = "已提交撤销申请"
    elsif action == "return"
      OrderMailer.apply_return(@order, @chef).deliver!
      flash[:notice] = "已提交退货申请"
    end
    redirect_to :back
  end

  def pay_with(method)
    @order.set_payment_with!(method)
    @order.make_payment!

    if method = "alipay"
      redirect_to order_path(@order.token), notice: "使用支付宝成功完成付款"
    elsif method = "wechat"
      redirect_to order_path(@order.token), notice: "使用微信支付功完成付款"
    end
  end

  def admin_do(action)
    @chef = ChefShadow.find_by(order_id: @order.id)
    if action == "ship"
      @order.ship!
      OrderMailer.notify_ship(@order, @chef).deliver!
    elsif action == "cancel"
      @order.cancell_order!
      OrderMailer.notify_cancel(@order, @chef).deliver!
    end
    redirect_to :back
  end

end
