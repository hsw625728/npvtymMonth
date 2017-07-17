//
//  MoVPNManage.h
//  VpnTest
//
//  Created by jiangqin on 16/7/11.
//  Copyright © 2016年 mopellet. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef void(^CompleteHandle)(BOOL success , NSString * returnInfo);
@interface MoVPNManage : NSObject

+ (id) shareVPNManage;

/**
 *  设置必要参数
 *
 *  @param server     主机HOST
 *  @param ID         账号
 *  @param pwd        密码
 *  @param privateKey 私钥
 */
- (void)setServer:(NSString *)server ID:(NSString *)ID pwd:(NSString *)pwd privateKey:(NSString *)privateKey;

/**
 *  设置标题
 */
- (void)setVpnTitle:(NSString *)vpnTitle;
-(void) loadFromPreferences:(CompleteHandle)completeHandle;
/**
 *  执行
 */
- (void) saveConfigCompleteHandle:(CompleteHandle)completeHandle;

/**
 *  断线重连 默认为NO
 */
- (void) setReconnect:(BOOL)reconnect;

- (void) vpnStart;

- (void) vpnStop;

@end
