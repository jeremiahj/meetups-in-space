As a user
I want to view a list of all available meetups
So that I can get together with people with similar interest

The browser should allow for new users to register
upon registration, user inputs should be stored in user database
the user database will hold all necessary information about the user.

  1. Create user DATABASE and Model
    i. rake db:create_migration NAME=create_users
    ii. db/migrate/...users
    iii. Complete Users migration
        Class CreateUsers < ActiveRecord::Migration
        def change
          create_table :users do |table|
            table.string :provider, null: false
            table.string :uid, null: false
            table.string :username, null: false
            table.string :email, null: false
            table.string :avatar_url, null: false

            table.timestamps null: false
          end

          add_index :users, [:uid, :provider], unique: true
        end
      end
      iv. app/models/user.rb and create user model
          class User < ActiveRecord::Base
          has_many :usermeetups
          has_many :meetups, through: :usermeetups

            def self.find_or_create_from_omniauth(auth)
              provider = auth.provider
              uid = auth.uid

              find_or_create_by(provider: provider, uid: uid) do |user|
                user.provider = provider
                user.uid = uid
                user.email = auth.info.email
                user.username = auth.info.name
                user.avatar_url = auth.info.image
              end
            end
          end
    v. rake db:migrate && rollback && migrate

  2. Create meetups DATABASE and MODEL
    i. rake db:create_migration NAME=create_meetups
    ii. db/migrate/...meetups
    iii. complete meetups migration
        Class Meetups < ActiveRecord::Migration
          def change
            create_table :Meetups do |c|
              c.string  :name, null: false, uniqueness: true
              c.text    :details, null: false, uniqueness: true
              c.text    :location, null: false

              c.timestamps null: false
            end
          end
        end
    iv. create model for meetup app/models/meetup.rb
        class Meetup < ActiveRecord::Base
        has_many :usermeetups
        has_many :users, through: :usermeetups

        validates :name, presence: true, uniqueness: true
        validates :details, presence: true, uniqueness: true
        validates :location, presence: true

        end
    v. rake db:migrate && rollback && migrate
  3. create JOINTABLE DATABASE and MODEL for users and meetups
    i. create usermeetups Database:
      rake db:create_migration NAME=create_user_meetups
    ii. complete migration: db/migrate/...usersmeetups.rb
        class UserMeetups < ActiveRecord::Migration
          def change
            create_table :usermeetups do |c|
              c.belongs_to :user, null: false
              c.belongs_to :meetup, null: false
            end
          end  
        end
    iii. complete MODEL for jointable usersmeetups:
        Class UserMeetup < ActiveRecord::Base
          belongs_to :user
          belongs_to :meetup

          validate :user, presence: true
          validate :meetup, presence: true
        end



As a user
I want to view a list of all available meetups
So that I can get together with people with similar interests
  1. On the meetups index page, I should see the name of each meetup. (Alphabetically)
    i. go to: app.rb
    ii. Set path by:
        get '/meetups' do
          erb :'meetups/index'
        end
    iii. Create instance variable that gives access to each meet up in alphabetical order
        #@meetups = Meetup.order(:name)
        iv. go to: views/index.erb
    v. iterate over #@meetups in proper HTML/erb
        <ul>
        <% #@meetups.each do |meetup| %>
          <li>
            <%= meetup %>
          </li>
        <% end %>
        </ul>


As a user
I want to view the details of a meetup
So that I can learn more about its purpose
  1. On the index page, the name of each meetup should be a link to the meetup's show page.
      i. go to: views/index.erb
      ii. add href
          <ul>
          <% #@meetups.each do |meetup| %>
            <li>
              <a href="/meetups/<% meetup %>"><%= meetup %></a>
            </li>
          <% end %>
          </ul>
      iii. go to: app.rb
      iv. create dynamic path:
          get '/meetups/:name' do
          end      
      v. create params
          get '/meetups/:name' do
          name = params[:name]
          erb :'meetups/show'
          end   
      vi. create show.erb in views folder

  2. On the show page, I should see the name, description, location, and the creator of the meetup.
      i. Complete dynamic path '/meetups/:name'
          get '/meetups/:name' do
            name = params[:name]
            #@meetups = Meetup.all
            #@meetups.each do |meetup|
              if meetup.name == name
                #@meetupname = meetup.name
                #@meetupdetail = meetup.detail
                #@meetuplocation = meetup.location
                end
              end
            erb :show
          end  
    ii. Populate show.erb with HTML/erb
        <h2> MEETUP </h2>
          <div><%= #@noerrormessage %></div>

          <div><strong>Meetup name:</strong> <%= #@meetupname %> <% || %> <%=@newmeetupname%></div>
          <div><strong>Meetup detail:</strong> <%= #@meetupdetail %> <% || %> <%=@newmeetupdetail%></div>
          <div><strong>Meetup location:</strong> <%= #@meetuplocation %> <% || %> <%=@newmeetuplocation%></div>
          <p><a href="/meetups">Homepage</a></p>

As a user
I want to create a meetup
So that I can gather a group of people to do an activity
  1. There should be a link from the meetups index page that takes you to the meetups new page. On this page there is a form to create a new meetup.
  2. I must be signed in, and I must supply a name, location, and description.

  3. If the form submission is successful, I should be brought to the meetup's show page, and I should see a message that lets me know that I have created a meetup successfully.
    i. create link on index.erb
      <p><a href="/meetups/newmeetup">CREATE NEW MEETUP</a></p>
    ii. create new path in app.rb:
        get '/meetups/newmeetup' do
        if
        params[:newmeetupname] == "" ||
        params[:newmeetupdetail] = "" ||
        params[:newmeetuplocation] = "" ||
        current_user.nil?

        #@newmeetupname = params[:newmeetupname]
        #@newmeetupdetail = params[:newmeetupdetail]
        #@newmeetuplocation = params[:newmeetuplocation]

        #@errormessage = "Oops you have not filled out the form completely!"
        erb :newmeetup

        else
        #@meetupmaker = current_user[:username]
        #@newmeetup = Meetup.create
        (
        name: "#{params[:newmeetupname]}",
        details: "#{params[:newmeetupdetail]},
        locaton: "#{params[:newmeetuplocation]}"
        )

        #@newmeetup.save

        #@noerrormessage = "Great you have just added a new meetup!"
        redirect "/meetups/" + "#{@newmeetup.name}"
        end
      end

    iii. create newmeetup.erb in the views file
    iv. populate newmeetup.erb with HTML/erb to satisfy goal:
        <h3> Please Enter Meetup Information </h3>
        <form action="/meetups/newmeetup" method="post">
            <label for="newmeetname">Name</label>
              <input type="text" id="name" name="newmeetupname" value="<%= #@newmeetupname %>">
            <label for="newmeetuplocation">Detail</label>
              <input type="text" id="location" name="newmeetuplocation" value="<%= #@newmeetupdlocation %>">
            <label for="newmeetupdetail">Detail</label>
              <input type="text" id="detail" name="newmeetupdetail" value="<%= #@newmeetupdetail %>">
            <input type="submit" value="submit">
        </form>
        <div><%= #@errormessage %></div>
    3.


    leads us to page with dynamic link .../:id]

    if you click on the button, goes to signups table and inputs current_user.id and meetup

    Usermeetup.create(user: current_user.id, meetup: @id)
