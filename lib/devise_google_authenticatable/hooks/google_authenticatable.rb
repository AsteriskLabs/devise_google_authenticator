Warden::Manager.after_set_user do |record, warden, options|
  respond_with record, :location => {:controller => 'checkga', :action => 'show'}
end
