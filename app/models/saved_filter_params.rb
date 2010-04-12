class SavedFilterParams < ActiveRecord::Base
  serialize :params

  def self.get_params(user_id, filter_name)
    find_by_user_id_and_filter_name(user_id, filter_name).try(:params) or {}
  end

  def self.store_params(user_id, filter_name, params)
    find_or_create_by_user_id_and_filter_name(:user_id => user_id, :filter_name => filter_name, :params => params)
  end
end
