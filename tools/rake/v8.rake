namespace :v8 do
  task :depot_tools do
    system("git submodule update --init #{$project_dir}/3rdparty/depot_tools")
  end

  task :build => :depot_tools do

    if not File.directory?( File.join($project_dir, "v8") ) then

      ENV['PATH'] = "#{$project_dir}/3rdparty/depot_tools:" + ENV['PATH']
      system("fetch v8")
      Dir.chdir("v8") do
        system("gclient sync")
        env ="GYP_GENERATORS=ninja GYP_DEFINES=\"clang=1 mac_deployment_target=10.7\" CXX=\"`which clang++` -std=c++11 -stdlib=libc++\" LINK=\"`which clang++` -std=c++11 -stdlib=libc++\""
        system("#{env} build/gyp_v8")
        system("#{env} ninja -C out/Debug d8")
      end

    end

  end

end

task :v8 => 'v8:build'
