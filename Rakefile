# encoding: utf-8
require 'find'
wd = `pwd`.chomp
build_dir = "#{wd}/build"

desc 'bundler and pod install'
task :setup do

  remove_dir(build_dir) if File.exists?(build_dir)
  mkdir_p(build_dir) unless File.exists?(build_dir)

  sh 'bundle install'
  sh 'rbenv rehash'
  sh 'bundle exec pod install'
end

