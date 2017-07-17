//
//  ViewController.m
//  VpnTest
//
//  Created by Pellet Mo on 15/12/14.
//  Copyright © 2015年 mopellet. All rights reserved.
//

#import "ViewController.h"
#import "MoVPNManage.h"
#import <NetworkExtension/NetworkExtension.h>
@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    MoVPNManage * vpnManage = [MoVPNManage shareVPNManage];
    [vpnManage setVpnTitle:@"梦游兔VPN"];
    [vpnManage setServer:@"47.89.38.166" ID:@"mengyoutu_cn" pwd:@"il18UI_3jHwN830d" privateKey:@"jJ38dh03dLIhrid"];
    [vpnManage setReconnect:NO];
    [vpnManage saveConfigCompleteHandle:^(BOOL success, NSString *returnInfo) {
        NSLog(@"%@",returnInfo);
        if (success) {
            [vpnManage loadFromPreferences:nil];
            [vpnManage vpnStart];
        }
    }];
    
    
    
    // ios 9 参考
    /*
    {
        NETunnelProviderManager * manager = [[NETunnelProviderManager alloc] init];
        NETunnelProviderProtocol * protocol = [[NETunnelProviderProtocol alloc] init];
        protocol.providerBundleIdentifier = @"cn.mengyoutu.vpn1";
        
        protocol.providerConfiguration = @{@"key":@"value"};
        protocol.serverAddress = @"47.89.38.166";
        manager.protocolConfiguration = protocol;
        //[manager saveToPreferencesWithCompletionHandler:^(NSError * _Nullable error) {
            
        //}];
        
        NETunnelProviderSession * session = (NETunnelProviderSession *)manager.connection;
        NSDictionary * options = @{@"key" : @"value"};
        
        NSError * err;
        [session startTunnelWithOptions:options andReturnError:&err];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            NSLog(@"%ld",(long)manager.connection.status);
        });
    }
     */
    
}

#pragma mark - 操作方法 BEGIN
- (IBAction)buttonPressed:(id)sender {
    [[MoVPNManage shareVPNManage] vpnStart];
}
- (IBAction)buttonStop:(id)sender {
    [[MoVPNManage shareVPNManage] vpnStop];
}

@end
