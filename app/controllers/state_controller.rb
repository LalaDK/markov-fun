class StateController < ApplicationController
  
  def index
    respond_to do |format|
      format.html do
        render "index"
      end
    end
  end
  
  def show
    respond_to do |format|
      format.json do
        left = params[:id] || ""
        left_size = (params[:left_size] || 5).to_i
        right_size = (params[:right_size] || 5).to_i
        render json: {result: State.speak(left, 200, left_size, right_size)}
      end
    end
  end
end