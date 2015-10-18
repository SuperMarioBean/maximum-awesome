ENV['HOMEBREW_CASK_OPTS'] = '--appdir=/Applications'
ENV['USER_GIT_REPOSITORY_DIRECTORY'] = "#{Dir.pwd}/.."

def brew_install(package, *args)
  versions = `brew list #{package} --versions`
  options = args.last.is_a?(Hash) ? args.pop : {}
  # if brew exits with error we install tmux
  if versions.empty?
    sh "brew install #{package} #{args.join ' '}"
  elsif options[:requires]
    # brew did not error out, verify tmux is greater than 1.8
    # e.g. brew_tmux_query = 'tmux 1.9a'
    installed_version = versions.split(/\n/).first.split(' ').last
    unless version_match?(options[:requires], installed_version)
      sh "brew upgrade #{package} #{args.join ' '}"
    end
  end
end

def version_match?(requirement, version)
  # This is a hack, but it lets us avoid a gem dep for version checking.
  # Gem dependencies must be numeric, so we remove non-numeric characters here.
  matches = version.match(/(?<versionish>\d+\.\d+)/)
  return false unless matches.length > 0
  Gem::Dependency.new('', requirement).match?('', matches.captures[0])
end

def install_github_bundle(user, package)
  unless File.exist? File.expand_path("~/.vim/bundle/#{package}")
    sh "git clone https://github.com/#{user}/#{package} ~/.vim/bundle/#{package}"
  end
end

def brew_cask_install(package, *options)
  output = `brew cask info #{package}`
  return unless output.include?('Not installed')

  sh("brew cask install --binarydir=#{`brew --prefix`.chomp}/bin #{package} #{options.join ' '}")
end

def step(description)
  description = "-- #{description} "
  description = description.ljust(80, '-')
  puts
  puts "\e[32m#{description}\e[0m"
end

def app_path(name)
  path = "/Applications/#{name}.app"
  ["~#{path}", path].each do |full_path|
    return full_path if File.directory?(full_path)
  end
end

def app?(name)
  !app_path(name).nil?
end

def get_backup_path(path)
  number = 1
  backup_path = "#{path}.bak"
  loop do
    if number > 1
      backup_path = "#{backup_path}#{number}"
    end
    if File.exist?(backup_path) || File.symlink?(backup_path)
      number += 1
      next
    end
    break
  end
  backup_path
end

def link_file(original_filename, symlink_filename)
  original_path = File.expand_path(original_filename)
  symlink_path = File.expand_path(symlink_filename)
  if File.exist?(symlink_path) || File.symlink?(symlink_path)
    if File.symlink?(symlink_path)
      symlink_points_to_path = File.readlink(symlink_path)
      return if symlink_points_to_path == original_path
      # Symlinks can't just be moved like regular files. Recreate old one, and
      # remove it.
      ln_s symlink_points_to_path, get_backup_path(symlink_path), :verbose => true
      rm symlink_path
    else
      # Never move user's files without creating backups first
      mv symlink_path, get_backup_path(symlink_path), :verbose => true
    end
  end
  ln_s original_path, symlink_path, :verbose => true
end

def unlink_file(original_filename, symlink_filename)
  original_path = File.expand_path(original_filename)
  symlink_path = File.expand_path(symlink_filename)
  if File.symlink?(symlink_path)
    symlink_points_to_path = File.readlink(symlink_path)
    if symlink_points_to_path == original_path
      # the symlink is installed, so we should uninstall it
      rm_f symlink_path, :verbose => true
      backups = Dir["#{symlink_path}*.bak"]
      case backups.size
      when 0
        # nothing to do
      when 1
        mv backups.first, symlink_path, :verbose => true
      else
        $stderr.puts "found #{backups.size} backups for #{symlink_path}, please restore the one you want."
      end
    else
      $stderr.puts "#{symlink_path} does not point to #{original_path}, skipping."
    end
  else
    $stderr.puts "#{symlink_path} is not a symlink, skipping."
  end
end

namespace :action do
  task :getDirectory do
    STDOUT.puts "Please Offer Your Default Git Repository Directory:(default is '#{ENV['USER_GIT_REPOSITORY_DIRECTORY']}')"
    input = STDIN.gets.strip
    if input == ''
    else
      ENV['USER_GIT_REPOSITORY_DIRECTORY'] = input
    end
    STDOUT.puts "OK We Will Use Directory: '#{ENV['USER_GIT_REPOSITORY_DIRECTORY']}'";
  end
end

namespace :install do
  desc 'Update or Install Brew'
  task :brew do
    step 'Homebrew'
    unless system('which brew > /dev/null || ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"')
      raise "Homebrew must be installed before continuing."
    end
  end

  desc 'Install prezto'
  task :prezto do
    step 'prezto'
    if Dir.exist?(Dir.home + "/.zprezto")
    else
      unless system("git clone --recursive https://github.com/sorin-ionescu/prezto.git '${ZDOTDIR:-$HOME}/.zprezto'")
        abort 'failed to install prezto'
      end
      unless system("
                    setopt EXTENDED_GLOB
                    for rcfile in '${ZDOTDIR:-$HOME}'/.zprezto/runcoms/^README.md(.N); do
                     ln -s '$rcfile' '${ZDOTDIR:-$HOME}/.${rcfile:t}'
                    done
                    ")
        abort 'failed to install prezto'
      end
      unless system("chsh -s /bin/zsh")
        abort 'failed to install prezto'
      end
    end
  end

  desc 'Install YouCompleteMe'
  task :YouCompleteMe do
    step 'YouCompleteMe'
    brew_install 'CMake'
    if Dir.exist?("#{ENV['USER_GIT_REPOSITORY_DIRECTORY']}/YouCompleteMe")
    else
      unless system("git clone https://github.com/Valloric/YouCompleteMe.git #{ENV['USER_GIT_REPOSITORY_DIRECTORY']}/YouCompleteMe && cd #{ENV['USER_GIT_REPOSITORY_DIRECTORY']}/YouCompleteMe && git submodule update --init --recursive && ./install.sh --clang-completer --system-libclang && cd .. ");
        abort 'failed to install YouCompleteMe'
      end
    end
  end

  desc 'Install The Silver Searcher'
  task :the_silver_searcher do
    step 'the_silver_searcher'
    brew_install 'the_silver_searcher'
  end

  desc 'Install ctags'
  task :ctags do
    step 'ctags'
    brew_install 'ctags'
  end

  desc 'Install reattach-to-user-namespace'
  task :reattach_to_user_namespace do
    step 'reattach-to-user-namespace'
    brew_install 'reattach-to-user-namespace'
  end

  desc 'Install autojump'
  task :autojump do
    step 'autojump'
    brew_install 'autojump'
  end

  desc 'Install tig'
  task :tig do
    step 'tig'
    brew_install 'tig'
  end

  desc 'Install NeoVim'
  task :neovim do
    step 'NeoVim'
    brew_install 'neovim/neovim/neovim'
  end

  desc 'Install vim-plug'
  task :vim-plug do
    step 'vim-plug'
    sh 'curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
    sh 'neovim -c "PlugInstall!" -c "q" -c "q"'
  end
end

def filemap(map)
  map.inject({}) do |result, (key, value)|
    result[File.expand_path(key)] = File.expand_path(value)
    result
  end.freeze
end

COPIED_FILES = filemap(
  'vimrc.local'         => '~/.vimrc.local',
  'vimrc.bundles.local' => '~/.vimrc.bundles.local'
)

LINKED_FILES = filemap(
  '/usr/local/bin/nvim' => '/usr/local/bin/vim',
  'nvim'                => '~/.config/nvim',
  'tigrc'               => '~/.tigrc',
  "#{ENV['USER_GIT_REPOSITORY_DIRECTORY']}/YouCompleteMe" => '~/.config/nvim/plugged/YouCompleteMe'
)

desc 'Install these config files.'
task :install do
  Rake::Task['install:brew'].invoke
  Rake::Task['install:prezto'].invoke
  Rake::Task['install:YouCompleteMe'].invoke
  Rake::Task['install:the_silver_searcher'].invoke
  Rake::Task['install:ctags'].invoke
  Rake::Task['install:reattach_to_user_namespace'].invoke
  Rake::Task['install:neovim'].invoke
  Rake::Task['install:autojump'].invoke
  Rake::Task['install:tig'].invoke

  # TODO: install gem ctags?
  # TODO: run gem ctags?

  step 'symlink'

  LINKED_FILES.each do |orig, link|
    link_file orig, link
  end

  COPIED_FILES.each do |orig, copy|
    cp orig, copy, :verbose => true unless File.exist?(copy)
  end

  # Install vim-plug and bundles
  Rake::Task['install:vim-plug'].invoke

  step 'Terminal.app colorschemes'
  colorschemes = `defaults read com.apple.terminal 'Default Window Settings'`
  dark  = colorschemes !~ /Solarized Dark/
  light = colorschemes !~ /Solarized Light/
  sh('open', '-a', '/Applications/Utilities/Terminal.app', File.expand_path('osx-terminal.app-colors-solarized/Solarized Dark.terminal')) if dark
  sh('open', '-a', '/Applications/Utilities/Terminal.app', File.expand_path('osx-terminal.app-colors-solarized/Solarized Light.terminal')) if light

  step 'Terminal.app profiles'
  puts
  puts 'Your turn!'
  puts ' '
  puts 'Go and manually set up Solarized Light and Dark profiles in Terminal.app.'
  puts "(You can do this in 'Preferences' -> 'Profiles' by adding a new profile,"
  puts 'and make it as a default.)'
  puts "Also be sure to set Terminal.app Type to 'xterm-256color' in the 'Terminal' tab."
  puts ' '
  puts 'Enjoy!'
  puts
end

desc 'Uninstall these config files.'
task :uninstall do
  step 'un-symlink'

  # un-symlink files that still point to the installed locations
  LINKED_FILES.each do |orig, link|
    unlink_file orig, link
  end

  # delete unchanged copied files
  COPIED_FILES.each do |orig, copy|
    rm_f copy, :verbose => true if File.read(orig) == File.read(copy)
  end
end

task :default => :install
