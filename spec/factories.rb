Factory.define :user do |user|
  user.name                   "Nick"
  user.email                  "nicholashibberd@hotmail.com"
  user.password               "password"
  user.password_confirmation  "password"
end

Factory.define :member do |member|
  member.name                   "Nick"
end

Factory.define :group do |group|
  group.name                "Test Group"
end

Factory.define :payment do |payment|
  payment.description   "New Payment"
  payment.amount        999
end

