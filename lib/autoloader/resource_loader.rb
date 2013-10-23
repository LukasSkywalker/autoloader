module Autoloader
    class ResourceLoader
        def initialize(action, params, opts)
            @action = action
            @params = params
            @opts = opts
            @klass = @opts[:scope]
            @model_params = params[@klass.name.underscore.to_sym]
        end
        
        def load_resource
            if load_instance?
                Rails.logger.info('load_resource_instance')
                load_resource_instance
                else
                Rails.logger.info('load_collection')
                load_collection
            end
            @resource
        end
        
        protected
        def load_instance?
            member_action?
        end
        
        def member_action?
            new_actions.include?(@action.to_sym) || @params[:id]
        end
        
        def collection_actions
            [:index]
        end
        
        def new_actions
            [:new, :create]
        end
        
        def load_resource_instance
            if new_actions.include?(@action.to_sym)
                Rails.logger.info('build_resource')
                build_resource
                elsif @params[:id]
                Rails.logger.info('find_resource')
                find_resource
                update_resource if @action == 'update'
            end
        end
        
        def update_resource
            Rails.logger.info('updating for ' + @klass.name)
            @resource.update_attributes(@model_params)
        end
        
        def load_collection
            Rails.logger.info('loading for ' + @klass.name)
            @resource = @klass.all
        end
        
        def build_resource
            Rails.logger.info('building for ' + @klass.name)
            @resource = @klass.new(@model_params || {})
        end
        
        def find_resource
            Rails.logger.info('finding for ' + @klass.name)
            @resource = @klass.find(@params[@opts[:identifier]])
        end
    end
    
end
