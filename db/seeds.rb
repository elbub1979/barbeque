# for clear db until seed rails db:reset

u1 = User.create(name: 'user1', email: 'user1@mail.ru')
u2 = User.create(name: 'user2', email: 'user2@mail.ru')

u1.events.create!(title: 'Mega-party', description: 'girls and boys invited', address: 'Moscow', datetime: Time.now)

u1.events.create!(title: 'The end of the world', address: 'Earth', datetime: Time.now + 200.years)

u1.save
u2.save
