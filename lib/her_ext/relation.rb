module HerExt
  module Relation
    def limit(limit)
      where('page[size]' => limit)
    end

    def order(args = [:id])
      column, order = args.respond_to?(:first) ? args.first : [args]
      column = "-#{column}" if order && order.to_sym == :desc
      where(sort: column.to_s)
    end
  end
end
