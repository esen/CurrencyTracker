class CurrenciesController < ApplicationController
  before_filter :authenticate_user!
  # GET /currencies
  # GET /currencies.xml
  def index
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @currencies }
    end
  end

  # GET /currencies/1
  # GET /currencies/1.xml
  def show
    @currency = Currency.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @currency }
    end
  end

  def update_collected
    respond_to do |format|
      format.json do
        @country = Currency.find(params[:id]).country rescue nil

        success = true

        if @country
          country_visited = @country.visitations.where(:user_id => current_user.id).count > 0
          new_visited_value = params[:visited] == 'true'

          if country_visited && !new_visited_value
            success = @country.visitations.where(:user_id => current_user.id).destroy_all
          elsif !country_visited && new_visited_value
            visitation = current_user.visitations.new
            visitation.country_code = @country.code
            success = visitation.save
            visited = 1
          end
        else
          ids = params[:ids] || []
          visited = visit_all_countries(ids)
        end

        if success 
          render :json => {:status => :OK, :visited_num => visited}
        else
          render :json => {:status => :ERROR, :visited_num => visited}
        end
      end
    end
  end

  def search
    respond_to do |format|
      format.json do
        @currencies = Currency.all_of_user(current_user, params[:filter_value].strip)

        render :partial => "currencies/table", :currencies => @currencies, :content_type => :text
      end
    end
  end

  private

  def visit_all_countries(ids)
    visited = 0
    ids.each do |id|
      country = Currency.find(id).country rescue nil
      if country
        country_visited = country.visitations.where(:user_id => current_user.id).count > 0
        unless country_visited
          visitation = current_user.visitations.new
          visitation.country_code = country.code
          visited += 1 if visitation.save
        end
      end
    end

    visited
  end
end