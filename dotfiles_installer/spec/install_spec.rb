require 'stringio'

# really, if command_line_helpers depends on config, it should just do that requiring itself
require 'haiti/config'
require 'haiti/command_line_helpers'
require 'install_dotfiles'

$root_dir = File.expand_path '../../', __FILE__
Haiti.configure do |config|
  config.bin_dir = "#{$root_dir}/bin"
end

describe 'installer' do
  include Haiti::CommandLineHelpers

  let(:stdin)  { StringIO.new }
  let(:stdout) { StringIO.new }

  def installer(options={})
    InstallDotfiles.new(options.fetch(:argv, []), stdin, stdout)
  end

  def symlink(options)
    installer(options).symlink(options)
  end

  def home_dir(dir)
    actual_home  = ENV['HOME']
    home_dir     = File.expand_path "#{$root_dir}/proving_grounds/#{dir}", __FILE__
    ENV['HOME']  = home_dir
    Haiti.configure { |config| config.proving_grounds_dir = home_dir }
    FileUtils.rm_rf home_dir
    make_proving_grounds
    yield home_dir
  ensure
    ENV['HOME'] = actual_home
  end

  describe 'symlink' do
    it 'symlinks the fullpath of the existing file to the link location' do
      home_dir 'symlink/good' do |home_dir|
        existing_file = "#{home_dir}/existing"
        new_file      = "#{home_dir}/new"
        symlink existing: existing_file, new: new_file
        expect(File.realdirpath new_file).to eq existing_file
      end
    end

    it 'does not prompt for overwrite if the new file is already a link to the existing one' do
      home_dir 'symlink/symlink_already_exists' do |home_dir|
        existing_file = "#{home_dir}/existing"
        new_file      = "#{home_dir}/new"
        symlink existing: existing_file, new: new_file # symlink it
        symlink existing: existing_file, new: new_file # this time, new already exists
        expect(File.realdirpath new_file).to eq existing_file
      end
    end

    describe 'after prompting when the file exists' do
      it 'prompts when new is a symlink to some other file' do
        home_dir "symlink/reprompts_when_symlinked_to_other" do |home_dir|
          desired_file = "#{home_dir}/desired"
          actual_file  = "#{home_dir}/actual"
          new_file     = "#{home_dir}/new"
          stdin.string = "wat\nyes\nrest"
          symlink existing: actual_file,  new: new_file
          symlink existing: desired_file, new: new_file
          expect(File.realdirpath new_file).to eq desired_file
          expect(stdin.read).to eq "rest"
        end
      end

      it 'prompts when the new is a file' do
        home_dir "symlink/reprompts_when_is_file" do |home_dir|
          existing_file = "#{home_dir}/existing"
          new_file      = "#{home_dir}/new"
          stdin.string  = "wat\nyes\nrest"
          FileUtils.touch new_file
          symlink existing: existing_file, new: new_file
          expect(File.realdirpath new_file).to eq existing_file
          expect(stdin.read).to eq "rest"
        end
      end

      it 'prompts when new is a directory' do
        home_dir "symlink/reprompts_when_is_directory" do |home_dir|
          existing_file = "#{home_dir}/existing"
          new_file      = "#{home_dir}/new"
          stdin.string  = "wat\nyes\nrest"
          FileUtils.mkdir new_file
          symlink existing: existing_file, new: new_file
          expect(File.realdirpath new_file).to eq existing_file
          expect(stdin.read).to eq "rest"
        end
      end

      it 'accepts words beginning with y to overwrite' do
        home_dir 'symlink/overwrite' do |home_dir|
          ['y', 'yes', 'Yes', 'YES', 'yodel'].each do |response|
            stdin.string  = response
            existing_file = "#{home_dir}/existing"
            new_file      = "#{home_dir}/new"
            FileUtils.rm_f new_file
            File.open(new_file, 'w') { |f| f.write 'some nonsense' }
            expect(File.realdirpath new_file).to_not eq existing_file
            symlink existing: existing_file, new: new_file
            expect(File.realdirpath new_file).to eq existing_file
          end
        end
      end

      it 'accepts words beginning with n to not overwrite' do
        home_dir 'symlink/no_overwrite' do |home_dir|
          ['n', 'N', 'no', 'No', 'NO', 'Nah'].each do |response|
            stdin.string  = response
            existing_file = "#{home_dir}/existing"
            new_file      = "#{home_dir}/new"
            FileUtils.rm_f new_file
            File.open(new_file, 'w') { |f| f.write 'some nonsense' }
            expect(File.realdirpath new_file).to_not eq existing_file
            symlink existing: existing_file, new: new_file
            expect(File.read new_file).to eq 'some nonsense'
          end
        end
      end

      it 'reprompts for anything else' do
        home_dir 'symlink/reprompt' do |home_dir|
          stdin.string  = "blah\nyes"
          existing_file = "#{home_dir}/yes_existing"
          new_file      = "#{home_dir}/yes_new"
          FileUtils.rm_f new_file
          File.open(new_file, 'w') { |f| f.write 'some nonsense' }
          expect(File.realdirpath new_file).to_not eq existing_file
          symlink existing: existing_file, new: new_file
          expect(File.realdirpath new_file).to eq existing_file

          stdin.string  = "blah\nno"
          existing_file = "#{home_dir}/no_existing"
          new_file      = "#{home_dir}/no_new"
          FileUtils.rm_f new_file
          File.open(new_file, 'w') { |f| f.write 'some nonsense' }
          expect(File.realdirpath new_file).to_not eq existing_file
          symlink existing: existing_file, new: new_file
          expect(File.read new_file).to eq 'some nonsense'
        end
      end
    end
  end

  describe 'append' do
    it 'makes the file if it DNE' do
      home_dir 'append/makes_file' do |home_dir|
        file = "#{home_dir}/some_dir/file"
        installer.append file, "content"
        expect(File.read file).to eq "content\n"
      end
    end

    it 'appends to the file if it exists and does not include the content' do
      home_dir 'append/appends_when_no_content' do |home_dir|
        file = "#{home_dir}/file"
        File.open(file, 'w') { |f| f.write "some_data\n" }
        installer.append file, "content"
        expect(File.read file).to eq "some_data\ncontent\n"
      end
    end

    it 'does not append to the file if it exists and does include the content' do
      home_dir 'append/appends_when_no_content' do |home_dir|
        file = "#{home_dir}/file"
        File.open(file, 'w') { |f| f.write "some_data\ncontent\nsome_more_data\n" }
        installer.append file, "content"
        expect(File.read file).to eq "some_data\ncontent\nsome_more_data\n"
      end
    end
  end


  describe 'installations' do
    around do |spec|
      home_dir "moves_all_files" do |home_dir|
        @home_dir  = home_dir
        invocation = execute 'install'
        expect(invocation.status).to be_success
        spec.call
      end
    end

    def actual(filename)
      File.expand_path "#$root_dir/../#{filename}"
    end

    it 'installs ackrc        to $HOME/.ackrc' do
      expect(File.realdirpath "#@home_dir/.ackrc").to eq actual 'ackrc'
    end

    it 'installs fish         to $HOME/.config/fish' do
      expect(File.realdirpath "#@home_dir/.config/fish").to eq actual 'fish'
    end

    it 'installs gemrc        to $HOME/.gemrc' do
      expect(File.realdirpath "#@home_dir/.gemrc").to eq actual 'gemrc'
    end

    it 'installs gitconfig    to $HOME/.gitconfig' do
      expect(File.realdirpath "#@home_dir/.gitconfig").to eq actual 'gitconfig'
    end

    it 'installs gitignore    to $HOME/.gitignore' do
      expect(File.realdirpath "#@home_dir/.gitignore").to eq actual 'gitignore'
    end

    it 'installs vimrc        to $HOME/.vimrc' do
      expect(File.realdirpath "#@home_dir/.vimrc").to eq actual 'vimrc'
    end

    it 'installs rspec        to $HOME/.rspec' do
      expect(File.realdirpath "#@home_dir/.rspec").to eq actual 'rspec'
    end

    describe 'bash_profile' do
      it 'appends the bin into the path' do
        bash_profile = File.read "#@home_dir/.bash_profile"
        expect(bash_profile).to include %Q(export PATH="#{actual 'bin'}:$PATH")
      end

      it 'appends the sourcing of the dotfiles bash_profile' do
        bash_profile = File.read "#@home_dir/.bash_profile"
        expect(bash_profile).to include %Q(source "#{actual 'bash_profile'}")
      end
    end

    describe 'fish/private_config.fish' do
      it 'appends the bin into the path' do
        private_config = File.read "#@home_dir/.config/fish/private_config.fish"
        expect(private_config).to include %Q(set --export PATH "#{actual 'bin'}" $PATH)
      end
    end
  end

  # vim -- makes the directory structure, clones the repos
end
