FactoryBot.define do
  factory :valid_user, class: 'User' do
    email { "frank.tennant@songkick.com" }
    password { "apple123" }
    name { "Frank Tennant" }
  end

  factory :invalid_user, class: 'User' do
    email { "frank.tennantsongkick.com" }
    password { "apple" }
    name { "" }
  end
end