class Admin::TagCharactersController < Admin::ApplicationController
  before_action :find_tag_character, only: [:edit, :update, :destroy]
  add_breadcrumb :tag_characters,
                 path: proc { admin_tag_characters_path },
                 with: [:new, :create, :destroy]

  before_action :build_tag_character, only: [:new, :create]

  def index
    @characters = Qa::TagCharacter.order(id: :desc).where(page_size_params.to_h)
  end

  def new; end

  def create
    save
  end

  def edit
    add_breadcrumb(@character.title)
  end

  def update
    add_breadcrumb(@character.title)
    save
  end

  def destroy
    @character.destroy
    redirect_to admin_tag_characters_path, success: t('flashes.destroy.success')
  end

  private

  def find_tag_character
    @character ||= Qa::TagCharacter.find(params[:id])
    raise Admin::NotFoundError unless @character
  end

  def build_tag_character
    @character = Qa::TagCharacter.new title: ''
  end

  def tag_character_params
    params.require(:tag_character).permit(:title)
  end

  def save
    @character.assign_attributes(tag_character_params.to_h)

    if @character.valid? && @character.save
      redirect_to_success edit_admin_tag_character_path(@character)
    else
      render_fail @character
    end
  end
end
