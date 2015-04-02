class CountriesController < ApplicationController
  before_filter :authenticate_user!
  # GET /countries
  # GET /countries.xml
  def index
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @countries }
    end
  end

  # GET /countries/1
  # GET /countries/1.xml
  def show
    @country = Country.find(params[:id])
    @country.assign_visited(current_user)

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @country }
    end
  end

  # GET /countries/1/edit
  def edit
    @country = Country.find(params[:id])
    @country.assign_visited(current_user)
  end

  # POST /countries
  # POST /countries.xml
  def create
    @country = Country.new(params[:country])

    respond_to do |format|
      if @country.save
        format.html { redirect_to(@country, :notice => 'Country was successfully created.') }
        format.xml  { render :xml => @country, :status => :created, :location => @country }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @country.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /countries/1
  # PUT /countries/1.xml
  def update
    @country = Country.find(params[:id])

    respond_to do |format|
      if @country.update_attributes(params[:country])
        country_visited = @country.visitations.where(:user_id => current_user.id).count > 0
        new_visited_value = params[:country][:visited].to_i > 0
        success = true

        if country_visited && !new_visited_value
          success = @country.visitations.where(:user_id => current_user.id).destroy_all
        elsif !country_visited && new_visited_value
          visitation = current_user.visitations.new
          visitation.country_code = @country.code
          success = visitation.save
        end

        if success 
          format.html { redirect_to(@country, :notice => 'Country was successfully updated.') }
          format.xml  { head :ok }
        else
          format.html { render :action => "edit" }
          format.xml  { render :xml => @country.errors, :status => :unprocessable_entity }
        end
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @country.errors, :status => :unprocessable_entity }
      end
    end
  end

  def update_visited
    respond_to do |format|
      format.json do
        @country = Country.find(params[:id])
        country_visited = @country.visitations.where(:user_id => current_user.id).count > 0
        new_visited_value = params[:visited] == 'true'

        success = true

        if country_visited && !new_visited_value
          success = @country.visitations.where(:user_id => current_user.id).destroy_all
        elsif !country_visited && new_visited_value
          visitation = current_user.visitations.new
          visitation.country_code = @country.code
          success = visitation.save
        end

        if success 
          render :json => {:status => :OK}
        else
          render :json => {:status => :ERROR}
        end
      end
    end
  end

  def search
    respond_to do |format|
      format.json do
        @countries = Country.all_of_user(current_user, params[:filter_value].strip)

        render :partial => "countries/table", :countries => @countries, :content_type => :text
      end
    end
  end
end