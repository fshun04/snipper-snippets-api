FactoryBot.define do
  factory :valid_snippet, class: 'Snippet' do
    content { "puts \"hello world!\"" }
  end
  factory :invalid_snippet, class: 'Snippet' do
    content { "" }
  end
end