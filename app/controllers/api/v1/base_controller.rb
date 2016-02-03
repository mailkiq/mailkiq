module API::V1
  class BaseController < ActionController::Metal
    include AbstractController::Rendering
    include ActionController::ConditionalGet
    include ActionController::Rendering
    include ActionController::Renderers
    include ActionController::StrongParameters
    include AbstractController::Callbacks
    include ActionController::Rescue
    include ActionController::Instrumentation

    use_renderers :json

    # def current_project
    #   @current_project ||= Project.find_by_api_key!(params[:project_id])
    # end

    # rescue_from ActiveRecord::RecordNotFound, :with => :missing_project

    # private

    # def missing_project
    #   render :json  => {
    #     'error' => 'No project was found with the given API key.'
    #   }, :status => :not_found
    # end
  end
end
