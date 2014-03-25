require 'stringio'

# really, if command_line_helpers depends on config, it should just do that requiring itself
require 'haiti/config'
require 'haiti/command_line_helpers'
require 'install_dotfiles'

$root_dir            = File.expand_path '../../', __FILE__
$proving_grounds_dir = "#$root_dir/proving_grounds"

Haiti.configure do |config|
  config.bin_dir = "#{$root_dir}/bin"
end

# reset after each
FileUtils.rm_rf $proving_grounds_dir

describe 'installer' do
  include Haiti::CommandLineHelpers

  let(:stdin)  { StringIO.new }
  let(:stdout) { StringIO.new }

  def installer
    InstallDotfiles.new(stdin, stdout)
  end

  def home_dir(dir)
    actual_home  = ENV['HOME']
    home_dir     = File.expand_path "#{$root_dir}/proving_grounds/#{dir}", __FILE__
    ENV['HOME']  = home_dir
    Haiti.configure { |config| config.proving_grounds_dir = home_dir }
    FileUtils.rm_rf home_dir
    make_proving_grounds
    yield home_dir
    home_dir
  ensure
    ENV['HOME'] = actual_home
  end

  describe 'symlink' do
    it 'symlinks the fullpath of the existing file to the link location' do
      home_dir 'symlink/good' do |home_dir|
        existing_file = "#{home_dir}/existing"
        new_file      = "#{home_dir}/new"
        installer.symlink existing: existing_file, new: new_file
        expect(File.realdirpath new_file).to eq existing_file
      end
    end

    it 'does not prompt for overwrite if the new file is already a link to the existing one' do
      home_dir 'symlink/symlink_already_exists' do |home_dir|
        existing_file = "#{home_dir}/existing"
        new_file      = "#{home_dir}/new"
        installer.symlink existing: existing_file, new: new_file # symlink it
        installer.symlink existing: existing_file, new: new_file # this time, new already exists
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
          installer.symlink existing: actual_file,  new: new_file
          installer.symlink existing: desired_file, new: new_file
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
          installer.symlink existing: existing_file, new: new_file
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
          installer.symlink existing: existing_file, new: new_file
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
            installer.symlink existing: existing_file, new: new_file
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
            installer.symlink existing: existing_file, new: new_file
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
          installer.symlink existing: existing_file, new: new_file
          expect(File.realdirpath new_file).to eq existing_file

          stdin.string  = "blah\nno"
          existing_file = "#{home_dir}/no_existing"
          new_file      = "#{home_dir}/no_new"
          FileUtils.rm_f new_file
          File.open(new_file, 'w') { |f| f.write 'some nonsense' }
          expect(File.realdirpath new_file).to_not eq existing_file
          installer.symlink existing: existing_file, new: new_file
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


  describe 'git_clone_or_pull' do
    before do
      home_dir 'git/fixture' do |fixture_dir|
        @fixture_dir = fixture_dir
        Dir.chdir fixture_dir do
          FileUtils.touch 'some_source_controlled_file'
          `git init`
          `git add .`
          `git commit -m 'Some commit'`
        end
      end
    end

    it 'clones the repo when the repo does not exist' do
      cloned_dir = File.expand_path('../cloned', @fixture_dir)
      installer.git_clone_or_pull @fixture_dir, cloned_dir
      expect(Dir.glob(cloned_dir+'/*').map { |fname| File.basename fname }).to eq ['some_source_controlled_file']
    end

    it 'pulls the repo when the repo does exist' do
      cloned_dir = File.expand_path('../cloned_before_changes', @fixture_dir)
      installer.git_clone_or_pull @fixture_dir, cloned_dir # initial clone
      Dir.chdir @fixture_dir do
        FileUtils.touch 'upstream_change'
        `git add .`
        `git commit -m 'Another file'`
        installer.git_clone_or_pull @fixture_dir, cloned_dir
        expect(Dir.glob(cloned_dir+'/*').map { |fname| File.basename fname }).to eq [
          'some_source_controlled_file',
          'upstream_change',
        ]
      end
    end

    it 'fails if the dir is not a git repo' do
      other_repo = home_dir 'git/not_git_repo' do |dir|
        Dir.chdir dir do
          FileUtils.touch 'existing-file'
        end
      end
      expect { installer.git_clone_or_pull @fixture_dir, other_repo }
        .to raise_error InstallDotfiles::CloneDirExistsError
    end
  end


  describe 'curl', t:true do
    before { Kernel.stub(:system).and_return('curl-result') }

    it 'makes the path to the directory to curl into' do
      target_dir = "#$proving_grounds_dir/curl/make_path/intermediate_directory"
      installer.curl target_dir+'/filename', 'some_url'
      expect(test 'd', target_dir).to eq true
    end

    it 'invokes curl with --silent and --show-error, the target, and the source and writes it to the file' do
      filename = "#$proving_grounds_dir/curl/check_args/filename"
      Kernel.should_receive(:system).with(%Q(curl -Sso #{filename.inspect} "some_url"))
      installer.curl filename, 'some_url'
    end

    it 'prompts for overwrite if the file already exists' do
      home_dir 'curl/already_exists' do |home_dir|
        Dir.chdir home_dir do
          FileUtils.touch 'filename'
          Kernel.should_receive :system
          stdin.string = "yes"
          installer.curl "#{home_dir}/filename", "some_url"
        end
      end

      home_dir 'curl/already_exists' do |home_dir|
        Dir.chdir home_dir do
          FileUtils.touch 'filename'
          Kernel.should_not_receive :system
          stdin.string = "no"
          installer.curl "#{home_dir}/filename", "some_url"
        end
      end
    end
  end


  describe 'integration' do
    def actual(filename)
      File.expand_path "#$root_dir/../#{filename}"
    end

    it 'actually installs everything' do
      home_dir "moves_all_files" do |home_dir|
        pending 'Integration is turned off in environment' if ENV['NO_INTEGRATION']
        @home_dir  = home_dir
        invocation = execute 'install'
        expect(invocation.status).to be_success

        # symlinks
        expect(File.realdirpath "#@home_dir/.ackrc"       ).to eq actual 'ackrc'     # ackrc     -> $HOME/.ackrc
        expect(File.realdirpath "#@home_dir/.config/fish" ).to eq actual 'fish'      # fish      -> $HOME/.config/fish
        expect(File.realdirpath "#@home_dir/.gemrc"       ).to eq actual 'gemrc'     # gemrc     -> $HOME/.gemrc
        expect(File.realdirpath "#@home_dir/.gitconfig"   ).to eq actual 'gitconfig' # gitconfig -> $HOME/.gitconfig
        expect(File.realdirpath "#@home_dir/.gitignore"   ).to eq actual 'gitignore' # gitignore -> $HOME/.gitignore
        expect(File.realdirpath "#@home_dir/.vimrc"       ).to eq actual 'vimrc'     # vimrc     -> $HOME/.vimrc
        expect(File.realdirpath "#@home_dir/.rspec"       ).to eq actual 'rspec'     # rspec     -> $HOME/.rspec

        # bash_profile
        bash_profile = File.read "#@home_dir/.bash_profile"
        expect(bash_profile).to include %Q(export PATH="#{actual 'bin'}:$PATH") # appends the bin into the path
        expect(bash_profile).to include %Q(source "#{actual 'bash_profile'}")   # appends the sourcing of the dotfiles bash_profile

        # fish/private_config.fish
        private_config = File.read "#@home_dir/.config/fish/private_config.fish"
        expect(private_config).to include %Q(set --export PATH "#{actual 'bin'}" $PATH) # appends bin into the path

        # .vim
        expect(File.readlines("#@home_dir/.vim/autoload/pathogen.vim").first) # installs pathogen
            .to eq %Q(" pathogen.vim - path option manipulation\n)
        expect(test 'd', "#@home_dir/.vim/bundle/nerdtree").to eq true # assume that if nerdtree exists, then all the plugins got installed
      end
    end
  end
end
