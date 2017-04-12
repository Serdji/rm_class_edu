module Routing
  class Admin
    class << self
      def matches?(request)
        return true if ROUTING_SUBDOMAINS.blank?
        (request.subdomain == ROUTING_SUBDOMAINS.fetch('admin', nil))
      end

      def present?
        ROUTING_SUBDOMAINS.present? && ROUTING_SUBDOMAINS.fetch('admin', nil).present?
      end
    end
  end
end
