module HasPhotos
  def build_photos(photos)
    if photos && photos['image']
      photos['image'].each do |a|
        self.photos.build(:image => a)
      end
    end
  end

end
