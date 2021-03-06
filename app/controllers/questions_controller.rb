class QuestionsController < ApplicationController

  #before_filter :check_round, :only => [:edit, :update]
  before_filter :admin_only, :only => [:edit, :update]

  # GET /questions/1
  # GET /questions/1.xml
  def show
    @question = Question.find(params[:id])

    if @question.round.published? || signed_in_as_admin?
      respond_to do |format|
        format.html # show.html.erb
        format.xml  { render :xml => @question }
      end
    else
      flash[:error] = 'Access denied.'
      redirect_to current_seasons_url
    end
  end

  # GET /questions/1/edit
  def edit
    @question = Question.find(params[:id])
  end

  # PUT /questions/1
  # PUT /questions/1.xml
  def update
    @question = Question.find(params[:id])

    respond_to do |format|
      if @question.update_attributes(params[:question])
        flash[:notice] = 'Question was successfully updated.'
        format.html { redirect_to question_url(@question) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @question.errors, :status => :unprocessable_entity }
      end
    end
  end

  protected
  def check_round
    question = Question.find(params[:id])
    if question.round.published?
      flash[:error] = I18n.t('errors.messages.question_prohibited_published_round')
      redirect_to current_seasons_url
      false
    end
  end
end

