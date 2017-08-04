# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
admin = User.new(name: 'Admin',
                    email: 'admin@host.io',
                    admin: true,
                    writer: true,
                    password: 'password')
admin.skip_confirmation_notification!
admin.save
admin.confirm

admin = User.new(name: 'Writer',
                    email: 'writer@host.io',
                    admin: false,
                    writer: true,
                    password: 'password')
admin.skip_confirmation_notification!
admin.save
admin.confirm

Post.create(user_id: admin.id,
           name: 'Welcome to mob!',
           body: <<~TEXT
                  Welocome to Mob - My own blog!
                  First - change password for Admin user:
                  default login - admin@host.io
                  default password - password
                  and Writer user:
                  default login - writer@host.io
                  default password - password
           TEXT
           )
