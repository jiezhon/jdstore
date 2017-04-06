class Product < ApplicationRecord
  include HasPhotos
  validates :title, presence: true
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
end
