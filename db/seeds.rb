user1 = User.create!(email: 'frank.tennant@songkick.com', password: 'apple123')
user2 = User.create!(email: 'evan.brown@songkick.com', password: 'orange123')

user1.snippets.create!(content: 'puts "hello world!')
user1.snippets.create!(content: 'my name is frank.')

user2.snippets.create!(content: 'puts "hello world!')
user2.snippets.create!(content: 'my name is evan.')
