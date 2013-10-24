# Autoloader

DRY up your controllers by autoloading the used models with AutoLoader

## Installation

Add this line to your application's Gemfile:

    gem 'autoloader'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install autoloader

## Usage

The `autoload_resource` controller macro will be automatically added to all your controllers. It lets you define which model you want to load based on what criteria.
Here is an example:

```
class SampleController < ApplicationController
  autoload :sample, :scope => { current_user.current_organization.samples }, :except => :other_action # note: the scope option does not currently work.

  def index
    # @samples is available
  end

  def show
    # @sample is available
    @comments = @sample.comments
  end

  def create
    # @sample is Sample.new(params[:sample])
    @sample.save
  end
end
```

The `autoload` call lets you define a few options to customize its behaviour.

You can use it as follows:

    autoload model, [options]
    
Options are
    
    :identifier (Symbol) which param to use to find the record. Default: :id
    
        autoload :user, :identifier => :member_id
        
    :only (Symbol) on which controller actions the record should be loaded
    
        autoload :user, :only => [:show, :index]
        
    :except (Symbol) on which actions to skip loading
    
        autoload :user, :except => :destroy
        
    :scope (Proc) the scope in which to search the record. Default: Model class
    
        autoload :user, :scope => Proc.new { User.administrators }
        # Produces User.administrators.find(#)
    

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
