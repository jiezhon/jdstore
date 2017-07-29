class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :set_locale, :set_timezone

  def admin_required
    if !current_user.admin?
      redirect_to "/", alert: "You are not admin."
    end
  end

  helper_method :current_cart

  def current_cart
    @current_cart ||= find_cart
  end

  def set_locale
   if params[:locale] && I18n.available_locales.include?( params[:locale].to_sym )
     session[:locale] = params[:locale]
   end

   I18n.locale = session[:locale] || I18n.default_locale
 end

  def set_timezone
    if current_user && current_user.time_zone
      Time.zone = current_user.time_zone
    end
  end

  private
  def find_cart
    if current_user
      cart = Cart.find_by(user_id: current_user.id)
    else
      cart = Cart.find_by(id: session[:cart_id])
    end

    if cart.blank?
      cart = Cart.create
      cart.user = current_user
      cart.save
    end
    session[:cart_id] = cart.id
    return cart
  end

end

Time::DATE_FORMATS.merge!(:default => '%Y/%m/%d %I:%M %p', :ymd => '%Y/%m/%d')
