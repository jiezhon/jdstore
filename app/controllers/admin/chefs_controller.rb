class Admin::ChefsController < AdminController
  before_action :find_chef, only: [:show, :edit, :update, :publish, :hidden]

  def index
    @chefs = Chef.all
  end

  def new
    @chef = Chef.new
    @photo = @chef.photos.build #for multi-pics
  end

  def create
    @chef = Chef.create(chef_params)

    if @chef.save
      if params[:photos] != nil
        params[:photos]['image'].each do |a|
          @photo = @chef.photos.create(:image => a)
        end
      end
      redirect_to admin_chefs_path, notice: "Chef Created."
    else
      render :new
    end
  end

  def edit
  end

  def update
    if params[:photos] != nil
      @chef.photos.destroy_all #need to destoy old pics first

      params[:photos]['image'].each do |a|
        @pictrue = @chef.photos.create(:image => a)
      end

      @chef.update(chef_params)
      redirect_to admin_chefs_path, notice: "Chef Updated."
    elsif @chef.update(chef_params)
      redirect_to admin_chefs_path, notice: "Chef Updated."
    else
      render :edit
    end
  end

  def show
    @photos = @chef.photos.all
  end

  def publish
    @chef.publish!
    redirect_to :back
  end

  def hidden
    @chef.hide!
    redirect_to :back
  end

  private
  def chef_params
    params.require(:chef).permit(:name, :description, :chef_level_id, :style, :image, :is_hidden, :phone, :city, :position)
  end

  def find_chef
    @chef = Chef.find(params[:id])
  end
end
