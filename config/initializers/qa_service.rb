unless Rails.env.test?
  begin
    require 'hashie'

    causes = Qa::ComplaintCause.all.map do |cause|
      hash = {
        id: cause.id.to_i, name: cause.name, human_name: cause.human_name
      }

      Hashie::Mash.new(hash)
    end
  rescue
    causes = []
  end

  Qa::ComplaintCause.const_get(:CAUSES).tap do |ary|
    causes.each { |cause| ary << cause }
  end
end
