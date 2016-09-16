# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Example:
#
#   Person.create(first_name: 'Eric', last_name: 'Kelly')

# Meetup.create(name: "Ultimate Fighting Champion", detail: "Fight to the death", location: "Elm street", user_id: 1)

# Usermeetup.create(user: User.first, meetup: Meetup.first)
Usermeetup.create(user: User.first, meetup: Meetup.last)
