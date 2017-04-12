Rails.application.config.assets.version = '1.0'
Rails.application.config.assets.precompile += %w(
  admin/application.css admin/application.js
  front/application.css front/application.js
  ramblertopline.js
)
