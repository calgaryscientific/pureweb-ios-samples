
desc "Cleans project"
task :clean do
    FileUtils.rm_r("PureWebSamples.xcworkspace") if File.exists?("PureWebSamples.xcworkspace")
    FileUtils.rm_r("Pods") if File.exists?("Pods")
    FileUtils.rm_r("Podfile.lock") if File.exists?("Podfile.lock")
end

desc "Configures project"
task :setup => [:clean] do
    sh("pod install")
end

task :default do
    sh("rake -T")
end
