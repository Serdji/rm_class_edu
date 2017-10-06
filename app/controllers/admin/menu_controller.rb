class Admin::MenuController < Admin::ApplicationController
  def index
    add_breadcrumb 'Меню тем'

    options = { has_questions: true, page: { size: 200 } }
    @tags = View::Qa::Tag.published(options)

    @menu_tag_groups = ::Menu::TagGroup.ordered
    @menu_tags = ::Menu::Tag.ordered
  end

  # rubocop:disable Metrics/AbcSize
  def save
    ::Menu::Tag.delete_all
    ::Menu::TagGroup.delete_all

    if params[:menu]
      save_tags if params[:menu][:tags]
      save_tag_groups if params[:menu][:tag_groups]
    end

    TagMenuBuilder.perform_now
    redirect_to admin_menu_path, success: 'Меню сохранено успешно'
  end
  # rubocop:enable Metrics/AbcSize

  private

  def tags_params
    params.require(:menu)
          .permit(tags: [:id, :tag_id, :position]).require(:tags)
  end

  def tag_groups_params
    params.require(:menu)
          .permit(tag_groups: [:id, :tag_id, :position, tag_ids: []]).require(:tag_groups)
  end

  def save_tags
    Menu::Tag.create(tags_params)
  end

  def save_tag_groups
    Menu::TagGroup.create(tag_groups_params)
  end
end
