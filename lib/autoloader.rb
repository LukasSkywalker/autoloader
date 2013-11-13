require 'autoloader/version'
require 'autoloader/resource_loader'
require 'autoloader/base_permission'
require 'autoloader/permission_finder.rb'

module Autoloader
  mattr_accessor :user_method

  def self.config(&block)
    yield(self)
  end

  module ControllerAdditions
    def autoload_resource(*args)
      name = args.first
      klass = Kernel.const_get(name.to_s.classify)

      opts = {
        :scope => Proc.new { klass },
        :identifier => :id,
        :user_method => Autoloader.user_method
      }.merge(args.extract_options! || {})

      self.send(:append_before_filter, opts.slice(:except, :only)) do |controller|
        scp = instance_exec(&opts[:scope])
        rl = ResourceLoader.new(controller, params, opts, scp)
        var_name = name.to_s
        var_name = name.to_s.pluralize if rl.plural?
        instance_variable_set(('@'+var_name.to_s).to_sym, rl.load_resource)
      end
    end
  end
end

ActionController::Base.class_eval do
  extend Autoloader::ControllerAdditions
end
