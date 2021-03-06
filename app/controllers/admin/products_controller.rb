class Admin::ProductsController < AdminController
  before_action :find_product, only: [:show, :edit, :update, :destroy, :publish, :hidden]

  def index
    @products = Product.where.not(:id => 1) #1 is a dummy product
  end

  def new
    @product = Product.new
    @product_photo = @product.photos.build #for multi-pics
  end

  def create
    @product = Product.create(product_params)
    @product.build_photos(params[:photos])

    if @product.save
      # if params[:photos] != nil
      #   params[:photos]['image'].each do |a|
      #     @product_photo = @product.photos.create(:image => a)
      #   end
      # end
      redirect_to admin_products_path, notice: "Product Created."
    else
      render :new
    end
  end

  def edit
  end

  def update

    if params[:photos] != nil
      @product.photos.destroy_all #need to destroy old pics first

      params[:photos]['image'].each do |a|
        @picture = @product.photos.create(:image => a)
      end

      @product.update(product_params)
      redirect_to admin_products_path

    elsif @product.update(product_params)
      redirect_to admin_products_path, notice: "Product Updated."
    else
      render :edit
    end
  end

  def show
    @photos = @product.photos.all
  end

  def destroy
    @product.destroy

    cart_items = CartItem.where(product_id: params[:id])
    cart_items.update_all(product_id: 1)

    redirect_to admin_products_path, alert: "Product deleted."
  end

  def publish
    @product.publish!
    redirect_to :back
  end

  def hidden
    @product.hide!
    redirect_to :back
  end

  private
  def product_params
    params.require(:product).permit(:title, :description, :quantity, :price, :image, :is_hidden, :style, :special)
  end

  def find_product
    @product = Product.find(params[:id])
  end
end
