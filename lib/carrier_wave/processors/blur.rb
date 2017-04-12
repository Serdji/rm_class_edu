module CarrierWave
  module Processors
    module Blur
      private

      class BlurParams < Struct.new(:params)
        def geometry
          params.fetch(:geometry)
        end

        def width
          geometry.first
        end

        def height
          geometry.last
        end

        def resize_to
          params.fetch(:resize_to, 0.0)
        end

        # TODO: not used while
        #
        # def radius
        #   params.fetch(:radius, 0.0)
        # end
        #
        # def sigma
        #   params.fetch(:sigma, 0.0)
        # end
      end

      def blurize(*args)
        params ||= BlurParams.new(args.to_h)

        manipulate! do |img|
          img.resize!(params.resize_to)
          img.crop_resized!(params.width, params.height)
        end
      end
    end
  end
end
