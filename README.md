# Capistrano::Recipes

A gem with some capistrano recipes we use for our projects. This gem is not published to rubygems.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'capistrano-recipes', :git => 'https://github.com/auxilium/capistrano-recipes.git'
```

Require all or some recipes in your `deploy.rb`

```ruby
# require all recipes
require 'capistrano-recipes'

# or include recipes one by one
# require 'capistrano-recipes/recipes/git'
# require 'capistrano-recipes/recipes/log'
# require 'capistrano-recipes/recipes/maintenance'
# require 'capistrano-recipes/recipes/nginx'
# require 'capistrano-recipes/recipes/postgresql'
# require 'capistrano-recipes/recipes/unicorn'
# require 'capistrano-recipes/recipes/uploads'
```

## Setup your project

By default the recipes come with `multistage` support. This means you need to structure your application to have the different stage enviroments configured in `config/deploy`. See the [example folder](example/) or the structure described below:

```
config/
  deploy/
    production.rb
    staging.rb
  deploy.rb
```

## Recipes

### Git

##### Commands

| command              | description                                  |
| -------------------- | -------------------------------------------- |
| `git:check_revision` | checks if the HEAD is the same as the origin |

##### default callbacks:

_before_: `deploy`, `deploy:migrations` and `deploy:cold` execute `git:check_revision`

### Log's

##### Commands

| command       | description                        |
| ------------- | ---------------------------------- |
| `log`         | defaults to `cap log:rails`        |
| `log:rails`   | tails the rails log                |
| `log:sidekiq` | tails the sidekiq log (if present) |
| `log:unicorn` | tails the unicorn log              |

### Maintenance

##### Settings

- `:maintenance_path` - _default:_ `"#{shared_path}/system/maintenance"`

##### Commands

| command                                 | description                                           |
| --------------------------------------- | ----------------------------------------------------- |
| `maintenance:on`                        | turns on the maintenance page                         |
| `maintenance:off`                       | turns off the maintenance page                        |
| `maintenance:update_maintenance_page`   | copies the maintenance page from `public/maintenance` |
| `maintenance:check_maintenance_present` | checks if `public/maintenance/index.html` exists      |

##### default callbacks:

_before_: `maintenance:on` execute `maintenance:check_maintenance_present`<br />
_after_: `deploy:update_code` execute `maintenance:update_maintenance_page`

### Nginx

##### Settings

- `:include_www_alias` - _default:_ `true`

##### Commands

| command         | description                              |
| --------------- | ---------------------------------------- |
| `nginx:setup`   | Creates a new site on the nginx instance |
| `nginx:start`   | Starts the nginx service                 |
| `nginx:stop`    | Stops the nginx service                  |
| `nginx:restart` | Restarts the nginx service               |

##### default callbacks:

_after_: `deploy:setup` execute `nginx:setup`

### PostgreSQL

##### Settings

- `:postgresql_create_user` - _default:_ Asked by capistrano
- `:postgresql_user` - _default:_ Asked by capistrano
- `:postgresql_password` - _default:_ Asked by capistrano
- `:postgresql_database` - _default:_ `"#{application}_#{stage}"`

##### Commands

| command                      | description                                                               |
| ---------------------------- | ------------------------------------------------------------------------- |
| `postgresql:setup`           | Creates a `database.yml` file                                             |
| `postgresql:create_database` | Creates the database and a user (unless it already exsists)               |
| `postgresql:create_symlink`  | Symlink the database.yml file                                             |
| `postgresql:pull`            | Pull the remote database and restore it on your local postgresql instance |

##### default callbacks:

_after_: `deploy:setup` execute `postgresql:create_database` and `postgresql:setup`<br />
_after_: `deploy:finalize_update` execute `postgresql:create_symlink`

### Unicorn

##### Settings

- `:unicorn_user` - _default:_ `user` meaning ssh user
- `:unicorn_pid` - _default:_ `"#{shared_path}/pids/unicorn.pid"`
- `:unicorn_sock` - _default:_ `"/tmp/unicorn.#{application}_#{stage}.sock"`
- `:unicorn_config` - _default:_ `"#{shared_path}/config/unicorn.rb"`
- `:unicorn_log` - _default:_ `"#{shared_path}/log/unicorn.log"`
- `:unicorn_workers` - _default:_ `2`
- `:unicorn_timeout` - _default:_ `30`

##### Commands

| command           | description                              |
| ----------------- | ---------------------------------------- |
| `unicorn:setup`   | Creates a unicorn config and init script |
| `unicorn:start`   | Starts the unicorns                      |
| `unicorn:stop`    | Stops the unicorns                       |
| `unicorn:restart` | Restarts the unicorns                    |
| `unicorn:upgrade` | Upgrades the unicorns                    |

##### default callbacks:

_after_: `deploy:setup` execute `unicorn:setup`<br />
_after_: 'deploy:start` execute `unicorn:start`<br />
_after_: 'deploy:stop` execute `unicorn:stop`<br />
_after_: 'deploy:restart` execute `unicorn:upgrade`

### Uploads

##### Settings

- `:upload_path` - _default:_ `"#{shared_path}/uploads"`

##### Commands

| command                  | description                                      |
| ------------------------ | ------------------------------------------------ |
| `uploads:setup`          | Creates and upload folder in `shared/uploads`    |
| `uploads:create_symlink` | Symlink `public/uploads` to shared upload folder |

##### default callbacks:

_after_: `deploy:setup` execute `uploads:setup`<br />
_after_: `deploy:create_symlink` execute `uploads:create_symlink`
