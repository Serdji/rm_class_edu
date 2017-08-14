every :day, at: '0:20am', roles: [:backend] do
  rake 'sitemap:create'
end

every :day, at: '0:25am', roles: [:backend] do
  rake 'sitemap:upload'
end

every 5.minutes, roles: [:backend] do
  runner 'TagMenuBuilder.perform_now'
end
