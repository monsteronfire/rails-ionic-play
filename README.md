# rails-ionic-play

### Desciption
Followed the tutorial below to hook an ionic up to a rails api (backend). Made a few adjustments. The tutorial is awesome on it's own, but texting it up for my future reference.

- [Reference Tutorial](https://www.youtube.com/watch?v=M3MnOZmGu3k&ab_channel=JoseWanKenobi)

### Set Up Rails
Generate a new rails app:
```
rails generate model person name phone
rake db:create
rake db:migrate
```

Seed some data by going to `db/seeds.rb` and pasting:
```ruby
Person.create(name: 'Lauren', phone: '0178889999')
Person.create(name: 'Joy', phone: '0167777777')
Person.create(name: 'Jon', phone: '0129999999')
```

Run
```
rake db:seed
```

Enter the `rails console`
```
rails c

```
In the `rails console`, check that the user data has been seeded, correctly:
```
Person.count
```

You should see that there are three users present: `(0.1ms)  SELECT COUNT(*) FROM "people"
 => 3 `

 Now proceed to adding an endpoint for the api. In `config/routes.rb`, make sure your code looks like this:

 ```ruby
Rails.application.routes.draw do
  namespace :api, contraints: { format: :json } do
    get 'people', to: 'agenda#all'
  end

end
 ```
Visit [Rack Cors Github](https://github.com/cyu/rack-cors) and add the following to your `Gemfile`:
```
gem 'rack-cors', :require => 'rack/cors'
```

In the terminal, run
```
bundle
```

In `config/application.rb`, make sure your file looks like the following:
```
Bundler.require(*Rails.groups)

module AgendaBackend
  class Application < Rails::Application
    
    config.active_record.raise_in_transactional_callbacks = true

    config.middleware.insert_before 0, "Rack::Cors" do
      allow do
        origins '*'
        resource '*', :headers => :any, :methods => [:get, :post, :options]
      end
    end
    
  end
end
```

Next, add the gem `gem 'active_model_serializers'` from the [Github page](https://github.com/rails-api/active_model_serializers) to your `Gemfile`. This will allow us to create JSON representations of our models.

In the terminal, run `bundle`.

Generate a serializer for `person`
```
rails generate serializer person
```

Open 'app/serializers/person_serializer.rb' and add the attributes to be serialized:
```
attributes :id, :name, :phone
```

Create the api controller:
```
rails generate controller api/agenda all --no-helper --no-assets
```

Open `app/controllers/api/agenda_controller.rb` and wrap it in a module like so:
```
module Api
  class AgendaController < ApplicationController

    respond_to :json

    def all
      render json: Person.all
    end

    def default_serializer_options
      { root: false }
    end
  end
end
```

Run the rails server
```
rails s
```

And test if the api is working:
```
curl -X GET 'http://localhost:3000/api/people'
```

### Create Ionic App
