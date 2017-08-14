server 'front-app02.stage.class.rambler.ru', roles: %w(front)
server 'back02.stage.class.rambler.ru',      roles: %w(backend db), primary: true
server 'cache02.stage.class.rambler.ru',     roles: %w(queue)

set :ssh_options, user: 'class'

set :webdav_endpoint, 'http://webdav01.park.rambler.ru/class_stage2'
set :webdav_roles, [:front, :backend]
