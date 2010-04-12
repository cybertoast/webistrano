module Webistrano
  module Template
    module Unicorn
      
      CONFIG = Webistrano::Template::Rails::CONFIG.dup.merge({
        :unicorn_init_script => "/etc/init.d/unicorn"
      }).freeze
      
      DESC = <<-'EOS'
        Get your unicorn on. 
      EOS
      
      TASKS = Webistrano::Template::Base::TASKS + <<-'EOS'
      
        namespace :webistrano do
          namespace :unicorn do
            %w(stop start restart upgrade).each do |t|
              desc "#{t.to_s.capitalize} unicorn"
              task t, :roles => :app, :except => { :no_release => true } do
                as = fetch(:runner, "app")
                invoke_command "#{unicorn_init_script} #{t.to_s}", :via => run_method, :as => as
              end
            end
          end
        end
        
        namespace :deploy do
          task :restart, :roles => :app, :except => { :no_release => true } do
            webistrano.unicorn.upgrade
          end
          
          task :start, :roles => :app, :except => { :no_release => true } do
            webistrano.unicorn.start
          end
          
          task :stop, :roles => :app, :except => { :no_release => true } do
            webistrano.unicorn.stop
          end
        end
      EOS
      
    end
  end
end
