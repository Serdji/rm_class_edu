class Front::UsersController < Front::ApplicationController
  def question_create
    session['first_question'] = safe_params.to_h
  end

  def question_show
    session.delete 'init'
    render json: session['first_question'].to_json
  end

  def question_clear
    session.delete 'first_question'
  end

  def safe_params
    params.require(:question).permit(:title, :body, tag_ids: [])
  end
end
