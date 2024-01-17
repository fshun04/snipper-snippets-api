FactoryBot.define do
  sequence :content_sequence do |n|
    case n
    when 1
      "puts \"hello world!\""
    when 2
      "pp \"hello world!\""
    when 3
      "Rails.logger.debug(\"hello world!\")"
    else
      "puts \"hello world!\""
    end
  end

  factory :snippet, class: 'Snippet' do
    content { generate(:content_sequence) }
    user
  end
end