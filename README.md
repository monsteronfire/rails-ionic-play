# rails-ionic-play

### Desciption
Followed the tutorial below to hook an ionic up to a rails api (backend). Made a few adjustments, so this readme actually deviates from the video in certain parts. The tutorial is awesome, so I'm texting it up for my future reference.

- [Reference Tutorial](https://www.youtube.com/watch?v=M3MnOZmGu3k&ab_channel=JoseWanKenobi)

###Getting Started
Create a folder to house the frontend (ionic) and backend (rails) or your app
```zsh
mkdir raionic
cd raionic
```

### Backend/API: Set Up Rails

In the `raionic` directory, generate a new rails app:

```zsh
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
```zsh
rake db:seed
```

Enter the `rails console`
```zsh
rails c

```
In the `rails console`, check that the user data has been seeded, correctly:
```zsh
Person.count
```

You should see that there are three users present: `(0.1ms)  SELECT COUNT(*) FROM "people"
 => 3 `

 Now proceed to adding an endpoint for the api. In `config/routes.rb`, make sure your code looks like this:

 ```ruby
Rails.application.routes.draw do
  namespace :api do
    get 'agenda/all'
  end

  namespace :api, contraints: { format: :json } do
    get 'people', to: 'agenda#all'
  end

end
 ```
Visit [Rack Cors Github](https://github.com/cyu/rack-cors) and add the following to your `Gemfile`:
```ruby
gem 'rack-cors', :require => 'rack/cors'
```

In the terminal, run
```zsh
bundle
```

In `config/application.rb`, make sure your file looks like the following:
```ruby
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
```zsh
rails generate serializer person
```

Open 'app/serializers/person_serializer.rb' and add the attributes to be serialized:
```ruby
attributes :id, :name, :phone
```

Create the api controller:
```zsh
rails generate controller api/agenda all --no-helper --no-assets
```

Open `app/controllers/api/agenda_controller.rb` and wrap it in a module like so:
```ruby
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
```zsh
rails s
```

And test if the api is working:
```zsh
curl -X GET 'http://localhost:3000/api/people'
```

### Frontend: The Ionic App
If you are in the rails directory, go back to your main directory, `raionic`:
```zsh
cd ../
```
Create a new, blank, Ionic app:
```zsh
ionic start agenda blank
cd agenda
```
Add the ios platform to your ionic app:
```zsh
ionic platform add ios
```

Run development environment (it will open in your browser):
```zsh
ionic serve
```

Open `agenda/www/index.html` and paste the list structure within `ion-content` tags:
```html
<ul class="list">
    <li class="item">
    ...
    </li>
</ul>
```
In `www/js`, create a new file called `controllers.js` and paste the following code into this newly created file:
```javascript
angular.module('starter.controllers', [])

.controller('PeopleController', 
  function($scope, $http) {
    //Adding the api endpoint
    var url = 'http://localhost:3000/api/people';

      $http.get(url)
      .success(function(people) {
        $scope.people = people;
      })
      .error(function(data) {
        console.log('Server side error occurred');
      });
  }
);
```

Don't forget to declare the module for the controller in the app dependencies `www/js/app,js`:
```javascript
angular.module('starter', ['ionic', 'starter.controllers'])
```
Now go to `www/index.html` to bind the controller to the list:
```html
<ul class="list" ng-controller="PeopleController">
    <li class="item" ng-repeat="person in people">
      {{person.name}}
    </li>
</ul>
```
Lastly, build the app and run it in the Xcode iPhone emulator:
```zsh
ionic build ios
ionic emulate ios
```