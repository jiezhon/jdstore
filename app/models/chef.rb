class Chef < ApplicationRecord
  mount_uploader :image, ImageUploader
  
  has_many :chef_times
  has_many :carts

  def publish!
    self.is_hidden = false
    self.save
  end

  def hide!
    self.is_hidden = true
    self.save
  end

  scope :published, -> { where(is_hidden: false) }
end
