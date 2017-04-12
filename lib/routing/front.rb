module Routing
  class Front
    class << self
      def matches?(request)
        return true if ROUTING_SUBDOMAINS.blank?
        (request.subdomain == ROUTING_SUBDOMAINS.fetch('front', nil))
      end

      def present?
        ROUTING_SUBDOMAINS.present? && ROUTING_SUBDOMAINS.fetch('front', nil).present?
      end
    end
  end
end
