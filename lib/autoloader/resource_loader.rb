module Autoloader
    class ResourceLoader
        def initialize(controller, params, opts, scope)
            @controller = controller
            @params = params
            @opts = opts
            @klass = scope
            @model_params = params[@klass.name.underscore.to_sym]
        end
        
        def action_name
            @controller.action_name
        end
        
        def identifier
            @params[@opts[:identifier]]
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
            new_actions.include?(action_name.to_sym) || identifier
        end
        
        def collection_actions
            [:index]
        end
        
        def new_actions
            [:new, :create]
        end
        
        def load_resource_instance
            if new_actions.include?(action_name.to_sym)
                Rails.logger.info('build_resource')
                build_resource
            elsif identifier
                Rails.logger.info('find_resource')
                find_resource
                update_resource if action_name == 'update'
            end
        end
        
        def update_resource
            Rails.logger.info('updating for ' + @klass.name)
            @resource.assign_attributes(@model_params)
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
            @resource = @klass.find(identifier)
        end
    end
    
end
