require 'chef/cookbook/metadata'

task default:  [:build, 'build:destroy', 'build:cucumber']
task validate: ['validate:berks', 'validate:rubocop', 'validate:foodcritic',
                'validate:reek', 'validate:knife', 'validate:chefspec']
task build:    [:validate, 'build:converge', 'build:verify']
task clean:    ['build:destroy']
task deploy:   ['deploy:delete', 'deploy:upload', 'berkshelf:delete']

###############################################################################
# validation tasks
###############################################################################
namespace :validate do
  desc 'Runs Berks to gather cookbook dependencies'
  task :berks do
    FileUtils.rm_f('Berksfile.lock')
    sh 'berks install'
  end

  desc 'Runs ChefSpec tests'
  task :chefspec do
    sh 'rspec'
  end

  desc 'Runs Foodcritic chef cookbook lint tool'
  task :foodcritic do
    sh 'foodcritic . --epic-fail any'
  end

  desc 'Runs Knife cookbook syntax error checks'
  task :knife do
    cb_path = File.realdirpath(File.dirname(Dir.pwd))
    sh "knife cookbook test #{metadata.name} --cookbook-path #{cb_path}"
  end

  desc 'Runs Reek Code smell detector'
  task :reek do
    sh 'reek .'
  end

  desc 'Runs Rubocop static code analyzer'
  task :rubocop do
    sh 'rubocop . -a'
  end
end

###############################################################################
# build tasks
###############################################################################
namespace :build do
  desc 'Runs Kitchen converge steps'
  task :converge do
    sh 'kitchen converge'
  end

  desc 'Runs Kitchen verify steps'
  task :verify do
    sh 'kitchen verify'
  end

  desc 'Runs Kitchen destroy steps'
  task :destroy do
    sh 'kitchen destroy'
    rm_rf '.kitchen'
  end

  desc 'Runs Cucumber acceptance tests'
  task :cucumber do
    sh 'cucumber'
  end
end

###############################################################################
# deploy tasks
###############################################################################
namespace :deploy do
  desc 'Deletes cookbook from the chef server'
  task :delete do
    cfg = metadata
    if cookbook_exists?(cfg)
      sh "knife cookbook delete #{cfg.name} #{cfg.version} -y"
    end
  end

  desc 'Uploads cookbook to the chef server'
  task upload: ['validate:berks'] do
    fail 'cookbook exists, will not overwrite' if cookbook_exists?
    sh 'berks upload --no-ssl-verify'
  end
end

###############################################################################
# berkshelf tasks
###############################################################################
namespace :berkshelf do
  desc 'Deletes cookbook from the berkshelf'
  task :delete do
    cfg     = metadata
    name    = cfg.name
    version = cfg.version
    if in_berkshelf?(name, version)
      sh "berks shelf uninstall #{name} -v #{version} -f"
    end
  end
end

###############################################################################
# functions
###############################################################################

def metadata
  metadata = Chef::Cookbook::Metadata.new
  metadata.from_file('metadata.rb')
  metadata
end

def cookbook_exists?(cfg = metadata)
  name    = cfg.name
  version = cfg.version
  found = `knife cookbook list -a | awk '$1 ~/#{name}$/ && /#{version}/'`
  found.length > 0
end

def in_berkshelf?(name, version)
  sh "berks shelf show #{name} -v #{version}" do |ok, _res|
    ok
  end
end
