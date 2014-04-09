//
//  PWProfilerView.h
//
//  Copyright 2012 Calgary Scientific Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <PureWeb/PureWeb.h>

@interface PWProfilerView : UIView
{
    __weak PWFramework *_framework;
    PWView *_view;
    UILabel *_mbps;
    UILabel *_requestFreq;
    UILabel *_responseFreq;
    UILabel *_handlersFreq;
    UILabel *_viewFps;
}

- (id)initWithFramework:(PWFramework *)framework view:(PWView *)view;
- (id)initWithFramework:(PWFramework *)framework frame:(CGRect)frame view:(PWView *)view;

@end
