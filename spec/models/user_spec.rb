require 'rails_helper'
require 'concerns/rolable_spec'

RSpec.describe User do
  it_behaves_like 'rolable'
end
