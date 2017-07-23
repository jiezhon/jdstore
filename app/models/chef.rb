class Chef < ApplicationRecord
  include HasPhotos
  validates_presence_of :name, :city, :friendly_id
  validates_uniqueness_of :friendly_id
  validates_format_of :friendly_id, :with => /\A[a-z0-9\-]+\z/

  before_validation :generate_friendly_id, :on => :create

  mount_uploader :image, ImageUploader

  has_many :chef_times
  has_many :carts

  has_many :favor_chefs_relationships
  has_many :followers, through: :favor_chefs_relationships, source: :user

  has_many :photos
  accepts_nested_attributes_for :photos

  has_many :chef_comments
  has_many :comments_from_user, through: :chef_comments, source: :user

  def publish!
    self.is_hidden = false
    self.save
  end

  def hide!
    self.is_hidden = true
    self.save
  end

  scope :published, -> { where(is_hidden: false) }
  scope :recent, -> { order('created_at') }

  def to_param
    self.friendly_id
  end

  protected

  def generate_friendly_id
    self.friendly_id ||= SecureRandom.uuid
  end
end
