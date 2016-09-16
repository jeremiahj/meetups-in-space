require 'sinatra'
require_relative 'config/application'
require 'pry'

helpers do
  def current_user
    if @current_user.nil? && session[:user_id]
      @current_user = User.find_by(id: session[:user_id])
      session[:user_id] = nil unless @current_user
    end
    @current_user
  end
end


get '/' do
  redirect '/meetups'
end

get '/auth/github/callback' do
  user = User.find_or_create_from_omniauth(env['omniauth.auth'])
  session[:user_id] = user.id
  flash[:notice] = "You're now signed in as #{user.username}!"

  redirect '/'
end

get '/sign_out' do
  session[:user_id] = nil
  flash[:notice] = "You have been signed out."

  redirect '/'
end

get '/meetups' do
  @meetups = Meetup.all

  erb :'meetups/index'
end

get '/meetups/newmeetup' do

  erb :'meetups/newmeetup'
end

post '/meetups' do
    @newmeetupname = params[:newmeetupname]
    @newmeetupdetail = params[:newmeetupdetail]
    @newmeetuplocation = params[:newmeetuplocation]
    @noerrormessage = nil
    @errormessage = nil
    @allmeetup = Meetup.all
    name_array = []

    @allmeetup.each do |meetup|
      name_array << meetup.name
    end

    if !name_array.include?(@newmeetupname)
      if !@newmeetupname.empty? && !@newmeetupdetail.empty? && !@newmeetuplocation.empty?
          @newmeetup = Meetup.create(name: @newmeetupname, detail: @newmeetupdetail, location: @newmeetuplocation, user_id: current_user.id)

          redirect "/meetups/new/#{@newmeetup.id}"
        else
          @errormessage = "Oops! you have not filled out the form completely OR event name already exists!"
          erb :'meetups/newmeetup'
      end
    end
end


get '/meetups/:id' do
  @id = params[:id].to_i
  @meet_up = Meetup.all
  @meetupObject = Meetup.find(@id)
  @creator = User.find(@meetupObject.user_id)

  @meet_up.each do |meetup|
    if meetup.id == @id
      @meetupname = meetup.name
      @meetupdetail = meetup.detail
      @meetuplocation = meetup.location
    end
  end

  @the_meetup = Meetup.find(@id)
  @users_for_meetup = @the_meetup.users

  erb :'meetups/show'
end

post '/meetups/:id' do
  @id = params[:id].to_i
  @meetupObject = Meetup.find(@id)

  array = []
  @meetupObject.users.each do |user|
    array << user.id
  end

  if !current_user.nil?
    if !array.include?(current_user.id)
      Usermeetup.create(user: current_user, meetup: meetupObject)
      redirect "/meetups/#{@id}"
    end
  else
    @meet_up = Meetup.all
    @meet_up.each do |meetup|
      if meetup.id == @id
        @meetupname = meetup.name
        @meetupdetail = meetup.detail
        @meetuplocation = meetup.location
      end
    end
    @errormessage3 = "You are not signed in or you are already signed-up for this meetup!"
    erb :'/meetups/show'
  end
end

get '/meetups/new/:id' do
  @noerrormessage = "Great you have just added a new meetup!"
  @id = params[:id].to_i
  @meet_up1 = Meetup.all
  @meet_up1.each do |meetup|
    if meetup.id == @id
      @meetupname = meetup.name
      @meetupdetail = meetup.detail
      @meetuplocation = meetup.location
    end
  end

  @the_meetup = Meetup.find(@id)
  @users_for_meetup = @the_meetup.users

  erb :'meetups/show'
end
