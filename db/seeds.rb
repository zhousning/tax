# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

role = Role.create(:name => Setting.roles.super_admin)

admin_permissions = Permission.create(:name => Setting.permissions.super_admin, :subject_class => Setting.admins.class_name, :action => "manage")

role.permissions << admin_permissions

user = User.new(:email => Setting.admins.email, :password => Setting.admins.email, :password_confirmation => Setting.admins.email)
user.save!

user.roles = []
user.roles << role

User.create(:email => "dayi@qq.com", :password => "dayi@qq.com", :password_confirmation => "dayi@qq.com")
