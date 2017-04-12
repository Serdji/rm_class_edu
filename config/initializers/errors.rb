module Front
  class NotFoundError < StandardError
  end

  class NotAuthenticatedError < StandardError
  end
end

module Admin
  class NotFoundError < StandardError
  end
end
