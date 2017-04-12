module CarrierWave
  module Processors
    module ThumbWithShadow
      private

      class Params < Struct.new(:params)
        def width
          params.fetch(:geometry).first
        end

        def height
          params.fetch(:geometry).last
        end

        def offset_x
          params.fetch(:offset_x)
        end

        def offset_y
          params.fetch(:offset_y)
        end

        def shadow_offset
          params.fetch(:shadow_offset)
        end

        def radius
          params.fetch(:blur).last
        end
      end

      # rubocop:disable Metrics/AbcSize
      def with_shadow(*args)
        params = Params.new(args.to_h)
        offset_x = params.offset_x
        offset_y = params.offset_y
        shadow_offset = params.shadow_offset

        manipulate!(format: 'png') do |img|
          img.resize_to_fill!(params.width, params.height)

          shadow = img.copy
          shadow.resize!(shadow.columns - offset_x, shadow.rows - offset_y)
          shadow.background_color = 'white'
          shadow = shadow.extent(
            shadow.columns + offset_x, shadow.rows + offset_y + shadow_offset,
            -offset_x / 2, -offset_y / 2 - shadow_offset
          )
          shadow = shadow.gaussian_blur(0, params.radius)

          img.background_color = 'transparent'
          img = img.extent(img.columns, img.rows + shadow_offset)
          shadow.composite(img, Magick::NorthGravity, Magick::OverCompositeOp)
        end
      end
    end
  end
end
