FactoryBot.define do
  factory :first_snippet, class: 'Snippet' do
    content { "puts \"hello world!\"" }
    user
  end
  factory :second_snippet, class: 'Snippet' do
    content { "pp \"hello world!\"" }
    user
  end
  factory :third_snippet, class: 'Snippet' do
    content { "Rails.logger.debug(\"hello world!\")" }
    user
  end
end