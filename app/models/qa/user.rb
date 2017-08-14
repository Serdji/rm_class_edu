class Qa::User < Qa::Base
  has_many :questions, class_name: 'Qa::Question'
  has_many :answers, class_name: 'Qa::Answer'

  loggable :update
  boolean_field :is_sentry, :is_fake

  class << self
    # rubocop:disable Rails/FindBy
    def find_by_chain_ids(ids)
      where(filter: { external_id: ids }).first
    end

    def create_from_rid_profile(rid)
      default_id = rid.profile.default_id
      profile_attrs = rid.profile_hash

      attributes = {
        external_id: default_id, external_id_type: 'rsid'
      }.merge(profile_attrs)

      create(attributes)
    end

    # TODO: simplify this
    # rubocop:disable Metrics/AbcSize
    def upload_csv(file)
      qa_config = Rails.application.config_for(:qa_api)

      faraday_options = {
        url: qa_config.fetch('domain'),
        headers: {
          'X-Api-Version' => qa_config.fetch('api_version'),
          'X-Api-Token' => qa_config.fetch('api_token')
        }
      }

      connection = Faraday.new(faraday_options) do |builder|
        builder.use Faraday::Request::Multipart
        builder.use Her::Middleware::AcceptJSON
        builder.use FaradayMiddleware::ParseJson
        builder.adapter Faraday.default_adapter
      end

      file = Faraday::UploadIO.new(file.path, 'text/csv')
      response = connection.post('users/update_fakers', csv: file)
      response.body
    end
  end

  # TODO: move from this
  def full_name
    name = [first_name, last_name].compact.join(' ')
    name.blank? ? "Ученик #{anonymous_id}" : name
  end

  def sync_with_rid(rid)
    clear_changes_information
    assign_attributes(rid.profile_hash)
    save if changed?
  end
end
