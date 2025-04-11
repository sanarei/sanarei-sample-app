require './config/environment'

run ApplicationController
use StaticPagesController
map('/users') { use UsersController }
