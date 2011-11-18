Warden::Manager.after_set_user do |record, warden, options|
  if record.respond_to?(:login_phase_one)
    if warden.session(options[:scope]).fetch(:gauth_phase_one,"nope") == "nope"
      redirect_to :controller => 'checkga', :action => 'show'
    end
    #warden.session(options[:scope])[:gauth_phase_one] 
  #respond_with record, :location => {:controller => 'checkga', :action => 'show'}
  end
end
