source "https://github.com/CocoaPods/Specs.git"
source "https://github.com/calgaryscientific/pureweb-ios-cocoapods"

workspace 'PureWebSamples'

use_frameworks!

platform :ios, '8.0'

PUREWEB='PureWeb'

xcodeproj 'Scribble/Scribble.xcodeproj'
target 'Scribble' do
    xcodeproj 'Scribble/Scribble.xcodeproj'
    pod "#{PUREWEB}"
end

xcodeproj 'Swift-Asteroids/Asteroids/Asteroids.xcodeproj'
target 'Asteroids' do
    xcodeproj 'Swift-Asteroids/Asteroids/Asteroids.xcodeproj'
    pod "#{PUREWEB}"
end 

xcodeproj 'DDx/DDx.xcodeproj'
target 'DDx' do
    xcodeproj 'DDx/DDx.xcodeproj'
    pod "#{PUREWEB}"
end

