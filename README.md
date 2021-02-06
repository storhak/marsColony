# README
## how to install ruby on rails
> follow the install guide in the following link 
    https://guides.rubyonrails.org/getting_started.html
> you only need to install ruby, node and yarn for ruby on rails

* Ruby version 2.7.2 https://rubyinstaller.org/downloads/
* Rails version 6.0.3.4
* Yarn version 1.22.5
* Node 12.16.1

## some terminal commands
> to run the server: 
```rails server```

> to migrate the schema to a database:
```rails db:migrate```

> after migration use the seeder for the resources and types:
```rails db:seed```

> to find the available routes:
```rails routes```

## to run all tests:
> switch to branch endpointDevelopment(this branch uses a sqlite3 database)

> run command
```rails db:migrate RAILS_ENV=test```

## deployement
> the api is currently deployed on heroku with an postgresql database
    https://warm-temple-98500.herokuapp.com/api/v1/

> if you want to deploy the api, use this guide
    https://devcenter.heroku.com/articles/getting-started-with-rails6

> its important that you also seed the database or manualy add resources

## routes
### /api/v1/users
* GET    /api/v1/users {header: { "Authorization" => "bearer 'token'" }}
> shows all users

* GET    /api/v1/users/:id {header: { "Authorization" => "bearer 'token'" }}
> shows a user by id

* GET    /api/v1/users/:id/showMines {header: { "Authorization" => "bearer 'token'" }}
> shows a list of mines for a user

* GET    /api/v1/users/topTen
> shows top ten users by balance

* POST   /api/v1/users {params: {"user": { "name", "password" }}}
> creates a user and an inventory with inventory_resources for all resources

* PUT/PATCH  /api/v1/users/:id {header: { "Authorization" => "bearer 'token'" }} {params: {"user": { "name", "password", "balance", "inventory_id" }}}
> updates a user by id with one or more of the new params

* DELETE /api/v1/users/:id {header: { "Authorization" => "bearer 'token'" }}
> deletes user by id


### /api/v1/login
* POST   /api/v1/login {params: { "username", "password" }}
> login for user also returns a token that is required for almost all endpoints


### /api/v1/auto_login
* GET   /api/v1/auto_login {header: { "Authorization" => "bearer 'token'" }}
> autologin for user


### /api/v1/mines
* GET    /api/v1/mines {header: { "Authorization" => "bearer 'token'" }}
> shows all mines

* GET    /api/v1/mines/:id {header: { "Authorization" => "bearer 'token'" }}
> shows a mine by id

* POST   /api/v1/mines {header: { "Authorization" => "bearer 'token'" }} {params: {"mine": { "name", "user_id", "resource_id"}}}
> creates a mine, an inventory with the inventory_resource of the selected resource and mine_upgrades for all available upgrades

* PUT/PATCH  /api/v1/mines/:id {header: { "Authorization" => "bearer 'token'" }} {params: {"mine": { "name", "user_id", "resource_id", "inventory_id", "uraniumCost", "resourceCounter", "multiplier" }}}
> updates a mine by id with one or more of the new params

* PUT    /api/v1/mines/:id/buy {header: { "Authorization" => "bearer 'token'" }} {params: {"upgrade_id"}}
> buy an upgrade

* DELETE /api/v1/mines/:id {header: { "Authorization" => "bearer 'token'" }}
> deletes mine by id


### /api/v1/resources
* GET    /api/v1/resources {header: { "Authorization" => "bearer 'token'" }}
> shows all resources

* GET    /api/v1/resources/:id {header: { "Authorization" => "bearer 'token'" }}
> shows a resource by id

* POST   /api/v1/resources {header: { "Authorization" => "bearer 'token'" }} {params: { "name" }}
> creates a resource

* PUT/PATCH  /api/v1/resources/:id {header: { "Authorization" => "bearer 'token'" }} {params: { "name" }}
> updates a resource by id with one or more of the new params

* DELETE /api/v1/resources/:id {header: { "Authorization" => "bearer 'token'" }}
> deletes resource by id


### /api/v1/inventories
* GET    /api/v1/inventories {header: { "Authorization" => "bearer 'token'" }}
> shows all inventories


### /api/v1/upgrades
* GET    /api/v1/upgrades {header: { "Authorization" => "bearer 'token'" }}
> shows all upgrades

* GET    /api/v1/upgrades/:id {header: { "Authorization" => "bearer 'token'" }}
> shows an upgrade by id

* POST   /api/v1/upgrades {header: { "Authorization" => "bearer 'token'" }} {params: {"upgrade": {"name", "description", "cost", "value", "type_id"}}}
> creates an upgrade and the mine_upgrade for all mines

* PUT/PATCH  /api/v1/upgrades/:id {header: { "Authorization" => "bearer 'token'" }} {params: {"upgrade": {"name", "description", "cost", "value", "type_id"}}}
> updates an upgrade by id with one or more of the new params

* DELETE /api/v1/upgrades/:id {header: { "Authorization" => "bearer 'token'" }}
> deletes upgrade by id


### /api/v1/types
* GET    /api/v1/types {header: { "Authorization" => "bearer 'token'" }}
> shows all types


### /api/v1/colonies
* GET    /api/v1/colonies {header: { "Authorization" => "bearer 'token'" }}
> shows all colonies

* GET    /api/v1/colonies/:id {header: { "Authorization" => "bearer 'token'" }}
> shows a colony by id

* PUT    /api/v1/colonies/:id/research {header: { "Authorization" => "bearer 'token'" }} {params: {"component_id"}}
> research a component

* PUT    /api/v1/colonies/:id/produce {header: { "Authorization" => "bearer 'token'" }} {params: {"component_id"}}
> produce a component


### /api/v1/spaceports
* GET    /api/v1/spaceports {header: { "Authorization" => "bearer 'token'" }}
> shows all spaceports

* GET    /api/v1/spaceports/:id {header: { "Authorization" => "bearer 'token'" }}
> shows a spaceport by id

* PUT    /api/v1/spaceports/:id/research {header: { "Authorization" => "bearer 'token'" }} {params: {"ship_id"}}
> research a ship

* PUT    /api/v1/spaceports/:id/produce {header: { "Authorization" => "bearer 'token'" }} {params: {"ship_id"}}
> produce a ship


### /api/v1/components
* GET    /api/v1/components {header: { "Authorization" => "bearer 'token'" }}
> shows all components


### /api/v1/ships
* GET    /api/v1/components {header: { "Authorization" => "bearer 'token'" }}
> shows all ships