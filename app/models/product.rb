class Product < ApplicationRecord
  include HasPhotos
  validates_presence_of :title, :friendly_id
  validates_uniqueness_of :friendly_id
  validates_format_of :friendly_id, :with => /\A[a-z0-9\-]+\z/

  before_validation :generate_friendly_id, :on => :create
  mount_uploader :image, ImageUploader

  has_many :favor_product_relationships
  has_many :followers, through: :favor_product_relationships, source: :user

  #has_many :photos
  has_many :photos, :class_name => "ProductPhoto", :foreign_key => "product_id"
  #accepts_nested_attributes_for :photos
  accepts_nested_attributes_for :photos

  def publish!
    self.is_hidden = false
    self.save
  end

  def hide!
    self.is_hidden = true
    self.save
  end

  scope :published, -> { where(is_hidden: false) }
  scope :specialed, -> {where(special: true)}

  def to_param
    self.friendly_id
  end

  protected

  def generate_friendly_id
    self.friendly_id ||= SecureRandom.uuid
  end

end
