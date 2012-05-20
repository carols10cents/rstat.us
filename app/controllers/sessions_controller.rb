class SessionsController < ApplicationController
  def new
    @title = "sign in"
    redirect_to root_path && return if logged_in?
  end

  # We have a bit of an interesting feature with the POST to /login.
  # Normally, this would just log you in, but for super ease of use, we've
  # decided to make it sign you up if you don't have an account yet, and log
  # you in if you do. Therefore, we try to fetch your user from the DB, and
  # check if you're there, which is the first half of the `if`. The `else`
  # is your run-of-the-mill login procedure.
  def create
    u = warden.authenticate

    if u
      flash[:notice] = "Login successful."
      redirect_to root_path

    elsif warden.message == "Incorrect password"
      flash[:error] = "The password given for username \"#{params[:username]}\" is incorrect.

      If you are trying to create a new account, please choose a different username."
      render :new

    elsif warden.message == "User does not exist yet"
      # Grab the domain for this author from the request url
      params[:domain] = root_url

      author = Author.new_from_session!(session, params, root_url)

      @user = User.new :author => author,
                       :username => params[:username],
                       :email => params[:email],
                       :password => params[:password]

      if @user.valid?
        if params[:password].length > 0
          @user.save
          warden.set_user(@user)
          flash[:notice] = "Thanks for signing up!"
          redirect_to root_path
          return
        else
          @user.errors.add(:password, "can't be empty")
        end
      end

      render :new
    end
  end

  def destroy
    warden.logout
    flash[:notice] = "You've been logged out."
    redirect_to root_path
  end

end
