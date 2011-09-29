class SearchesController < ApplicationController
  def show
    if params[:hashtag]
      @hashtag = params[:hashtag]
      render_index(Update.hashtag_search(@hashtag, params))
    else
      @results = []

      if params[:q]
        set_params_page

        case params[:scope]
        when "updates"
          @results = Update.where(
                       :text => /\b#{Regexp.quote(params[:q])}\b/i
                     ).paginate(
                       :page     => params[:page],
                       :per_page => params[:per_page],
                       :order    => :created_at.desc
                     )
        when "users"
          @results = User.where()
        end

        set_pagination_buttons(@results)
      end
    end
  end

  # DERP, this duplication sucks, and this code kinda sucks
  # anyway. Let's see if we can't remove it in the future.
  def set_pagination
    set_params_page
    @updates = @updates.paginate(:page => params[:page], :per_page => params[:per_page], :order => :created_at.desc)
    set_pagination_buttons(@updates)
  end

  # Render correct haml depending on request type
  def render_index(updates)
    @updates = updates
    set_pagination
    render :index, :layout => show_layout?
  end
end
