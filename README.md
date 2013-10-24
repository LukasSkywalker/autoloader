# Autoloader

DRY up your controllers by autoloading the used models with AutoLoader. With Autoloader, you can get rid of those tedious and repetitive `User.find(params[:id])`-calls and enjoy the real programming of the controllers.

## Installation

Add this line to your application's Gemfile:

    gem 'autoloader'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install autoloader

## Usage

The `autoload_resource` controller macro will automatically be added to all your controllers. It lets you define which model you want to load based on your own criteria.

The `autoload_resource` call lets you define a few options to customize its behaviour. You can use it as follows:

    autoload_resource model, [options]
    
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
        
## Example

That's some though stuff to understand. Here's an example to make it more clear:

```
class PostController < ApplicationController
  autoload_resource :post, :scope => { current_user.posts }, :except => :share 

  def index
    # @posts is available, can be used directly in view
  end

  def show
    # @post is available
    @comments = @sample.comments
  end

  def create
    # @post is Post.new(params[:post])
    @post.save
  end
  
  def share
  	FacebookConnector.publish_all
  end
end
```
The above code tells autoloader to automatically load the `Sample`-model on all actions except for the `share` action. That means that the entire collection of posts is loaded for the `index` action, and one post for each of the other actions (`show`, `new`, `create`, `edit`, `update`, `destroy`). To see how the records are generated, read the **How Records Are Loaded** section.

## How Records Are Loaded

Autoloader uses a different strategy to load the models for the different actions. Here is a list how they work, in this example with a call to `autoload_resource :post`:

* `show`: A single record is loaded with `Post.find(:id)` and available as `@post`
* `index`: All records in the defined scope are loaded with `Post.all` and available as `@posts`
* `new`: A new record is initalized with `Post.new` and available as `@post`
* `create`: A new record, initalized with the attributes in `params[:post]`, but not yet saved, is available as `@post`
* `edit`: A single record, obtained with `Post.find(:id)` is available as `@post`
* `update`: A single record, updated with the attributes in `params[:post]`, but not yet saved, is available as `@post`
* `destroy`: A single record, loaded with `Post.find(:id)` is available in `@post`
* Custom actions: if the `id` parameter is available, a single record is loaded (similar to the show action). Otherwise, all records are loaded (similar to the index action)
        
## Multiple Loaders

If you really need to, you can define multiple loaders in a single controller. Consider an application with the `Group` and `Contact` models, which reference each other with a `has_many` relation.
The controller could look as follows:

```
class GroupsController < ApplicationController
  autoload_resource :group
  autoload_resource :contact, :identifier => :contact_id, :only => [:add_contact, :remove_contact]

  def create
    current_user.groups << @group
    redirect_to contacts_path
  end

  def add_contact
    ContactBook.new.for(current_user).add_to_group(@contact, @group)
    redirect_to contacts_path
  end

  def remove_contact
    @group.contacts.delete @contact
    redirect_to contacts_path
  end

  def destroy
    @group.destroy
    redirect_to contacts_path
  end


  private

  def group_params
    params.required(:group).permit(:name)
  end
end

```
    

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
