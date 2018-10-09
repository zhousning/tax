# coding: utf-8

namespace :tax do
  desc "tax tasks"
  task :tasks do
    Rake::Task["db:drop"].invoke
    Rake::Task["db:create"].invoke
    Rake::Task["db:migrate"].invoke
    Rake::Task["db:seed"].invoke
    Rake::Task["db:add_permissions"].invoke
    Rake::Task["assets:precompile"].invoke
  end
end
