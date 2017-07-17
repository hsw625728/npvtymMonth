//
//  AppDelegate.h
//  VpnTest
//
//  Created by Pellet Mo on 15/12/14.
//  Copyright © 2015年 mopellet. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, assign) VPNSTATUE gStatue;

- (void)updateStatue:(VPNSTATUE)s;

@end

