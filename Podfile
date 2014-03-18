workspace 'PureWebSamples'

platform :ios, '7.0'

PUREWEB='PureWebNightly'

xcodeproj 'Scribble/Scribble.xcodeproj'
target 'Scribble' do
    xcodeproj 'Scribble/Scribble.xcodeproj'
    pod "#{PUREWEB}"

end

xcodeproj 'Asteroids/Asteroids.xcodeproj'
target 'Asteroids' do
    xcodeproj 'Asteroids/Asteroids.xcodeproj'
    pod "#{PUREWEB}"

end 

xcodeproj 'DDx/DDx.xcodeproj'
target 'DDx' do
    xcodeproj 'DDx/DDx.xcodeproj'
    pod "#{PUREWEB}"

end

target 'PureWebUI' do
    xcodeproj 'PureWebUI/PureWebUI.xcodeproj'
    pod "#{PUREWEB}"    
end

