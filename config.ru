require './config/environment'

use PublicPageCache
run ApplicationController
use StaticPagesController
map('/users') { use UsersController }
