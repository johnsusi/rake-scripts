namespace :opencv do

  opencv_build_dir=File.join($tmp_dir, 'opencv-build')

  task :checkout do
    system("git submodule update --init #{$project_dir}/3rdparty/opencv")
  end

  task :configure => :checkout do

    return if File.directory?(opencv_build_dir)

    FileUtils.mkdir_p(opencv_build_dir)
    Dir.chdir(opencv_build_dir) do

      system("cmake #{$project_dir}/3rdparty/opencv -GNinja -DCMAKE_INSTALL_PREFIX=#{$project_dir}/opencv -DBUILD_TESTS=NO -DBUILD_PERF_TESTS=NO -DINSTALL_TESTS=NO")

    end

  end

  task :build => :configure do
    system("cmake --build #{opencv_build_dir}")
  end

  task :install => :build do
    system("cmake --build #{opencv_build_dir} --target install")
  end

end

task :opencv => 'opencv:install'
