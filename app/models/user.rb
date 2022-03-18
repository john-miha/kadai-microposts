class User < ApplicationRecord
  validates :name, presence: true, length: { maximum: 50 }
  validates :email, presence: true, length: { maximum: 255 },
                    format: { with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i },
                    uniqueness: { case_sensitive: false }
  has_secure_password
  
  has_many :microposts
  has_many :relationships
  has_many :followings, through: :relationships, source: :follow
  has_many :reverses_of_relationship, class_name: 'Relationship', foreign_key: 'follow_id'
  has_many :followers, through: :reverses_of_relationship, source: :user
  
  #お気に入り機能。
  #中間テーブルへの参照
  has_many :favorites
  #中間テーブルへの逆向きの参照
  has_many :reverses_of_favorite, class_name: 'favorite', foreign_key: 'micropost_id' 
  #あるユーザーがお気に入りに登録しているマイクロポスト
  has_many :fav_microposts, through: :favorites, source: :micropost
  #あるマイクロポストをお気に入りに登録しているユーザー
  has_many :faved_by_users, through: :reverses_of_favorite, source: :user
  
  def follow(other_user)
    unless self == other_user
      self.relationships.find_or_create_by(follow_id: other_user.id)
    end
  end
  
  def unfollow(other_user)
    relationship = self.relationships.find_by(follow_id: other_user.id)
    relationship.destroy if relationship
  end
  
  def following?(other_user)
    self.followings.include?(other_user)
  end
  
  def feed_microposts
    Micropost.where(user_id: self.following_ids + [self.id])
  end
  
  
  def favorite(fav_micropost)
    #todo
    #既にお気に入りに登録しているかチェック
    #追加していなければ
    #当該ポストをお気に入りに追加
    #追加していれば
    #何もしない
    unless favorite?(fav_micropost)
      self.favorites.find_or_create_by(micropost_id: fav_micropost.id)
    end
  end
  
  def unfavorite(micropost)

    favorite = self.favorites.find_by(micropost_id: micropost.id)
    favorite.destroy if favorite
  end
  
  def favorite?(micropost)
    self.fav_microposts.include?(micropost)
  end

end
