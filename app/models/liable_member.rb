class LiableMember < ActiveRecord::Base
  belongs_to :member
  belongs_to :payment
end
