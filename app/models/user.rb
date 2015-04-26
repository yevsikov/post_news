class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  has_many :posts, dependent: :destroy

  has_attached_file :avatar, :styles => { :medium => "300x300>", :thumb => "100x100>" },
                    :default_url => "/images/:style/missing.png"
  validates_attachment_content_type :avatar, :content_type => /\Aimage\/.*\Z/

  validates :username, :email, uniqueness: true
  validates :username, :email, presence: true

  after_create :check_last_stand

  # methods that make the admins from newbie
  def admin!
    self.rank = 4
    self.save
  end

  def editor!
    self.rank = 3
    self.save
  end

  def author!
    self.rank = 2
    self.save
  end

  def corrector!
    self.rank = 1
    self.save
  end

  # methods that check the user status
  def newbie?
    rank == 0
  end

  def admin?
    rank == 4
  end

  def editor?
    rank == 3
  end

  def author?
    rank == 2
  end

  def corrector?
    rank == 1
  end

  def check_last_stand
    if self.alone?
      self.admin!
    end
  end

  def alone?
    return true if User.count == 1 && User.all.first == self
    false
  end
end
