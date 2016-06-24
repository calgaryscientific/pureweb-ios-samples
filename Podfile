source "https://github.com/CocoaPods/Specs.git"
source "https://github.com/calgaryscientific/pureweb-ios-cocoapods"

workspace 'PureWebSamples'

use_frameworks!

platform :ios, '8.0'

PUREWEB='PureWeb'

project 'Scribble/Scribble.xcodeproj'
target 'Scribble' do
    project 'Scribble/Scribble.xcodeproj'
    pod "#{PUREWEB}"
end

project 'Swift-Asteroids/Asteroids/Asteroids.xcodeproj'
target 'Asteroids' do
    project 'Swift-Asteroids/Asteroids/Asteroids.xcodeproj'
    pod "#{PUREWEB}"
end 

project 'DDx/DDx.xcodeproj'
target 'DDx' do
    project 'DDx/DDx.xcodeproj'
    pod "#{PUREWEB}"
end

