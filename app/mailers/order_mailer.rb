class OrderMailer < ApplicationMailer

  # def notify_order_placed(order, chef)
  #   get_order_information(order, chef)
  #   mail(to: @user.email, subject: "[JDstore] 感谢您完成本次的下单，以下是您这次购物明细 #{order.token}")
  # end

  def apply_action(order, chef, action)
    get_order_information(order, chef)
    if action=="cancel"
      mail(to: "admin@test.com", subject: "[JDstore] 用户#{order.user.email}申请取消订单 #{order.token}")
    elsif action=="return"
      mail(to: "admin@test.com", subject: "[JDstore] 用户#{order.user.email}申请退货 #{order.token}")
    end
  end

  # def apply_return(order, chef)
  #   get_order_information(order, chef)
  #   mail(to: "admin@test.com", subject: "[JDstore] 用户#{order.user.email}申请退货 #{order.token}")
  # end

  # def notify_ship(order, chef)
  #   get_order_information(order, chef)
  #   mail(to: @user.email, subject: "[JDStore] 您的订单 #{order.token}已发货")
  # end

  # def notify_cancel(order, chef)
  #   get_order_information(order, chef)
  #   mail(to: @user.email, subject: "[JDStore] 您的订单 #{order.token}已取消")
  # end

  def notify_status(order, chef, status)
    get_order_information(order, chef)
    case status
    when 'order_placed'
      mail(to: @user.email, subject: "[JDstore] 感谢您完成本次的下单，以下是您这次购物明细 #{order.token}")
    when 'ship'
      mail(to: @user.email, subject: "[JDStore] 您的订单 #{order.token}已发货")
    when 'cancel'
      mail(to: @user.email, subject: "[JDStore] 您的订单 #{order.token}已取消")
    end
  end

  private

  def get_order_information(order, chef)
    @order = order
    @chef = chef
    @user = order.user
    @product_lists = @order.product_lists
  end

end
