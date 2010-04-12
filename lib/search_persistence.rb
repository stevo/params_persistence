module SearchPersistence

  def self.included(base)
    base.extend ControllerMethods
  end

  module ControllerMethods

    def set_search_persitence(*args)
      cattr_accessor :search_persistence_options

      self.search_persistence_options = args.extract_options!

      self.search_persistence_options.tap do |options|
        options[:params_key] ||= :search
        options[:name] ||= controller_name.to_s
        options[:actions] ||= [:index]
      end

      include ::SearchPersistence::ProtectedMethods

      before_filter :cache_search_params, :actions => search_persistence_options[:actions]

    end
  end

  module ProtectedMethods
    private
    def cache_search_params
      if current_user and (!current_user.respond_to?(:skip_filter_saving?) or !current_user.skip_filter_saving?(search_persistence_options[:name]))
        if params[search_persistence_options[:params_key]].present?
          store_search_params
        else
          restore_search_params
        end
      end
    end

    def store_search_params
      SavedFilterParams.store_params(current_user.id, search_persistence_options[:name], params[search_persistence_options[:params_key]])
    end

    def restore_search_params
      params[search_persistence_options[:params_key]] ||= {}
      params[search_persistence_options[:params_key]].reverse_merge! SavedFilterParams.get_params(current_user.id, search_persistence_options[:name])
    end

  end

end