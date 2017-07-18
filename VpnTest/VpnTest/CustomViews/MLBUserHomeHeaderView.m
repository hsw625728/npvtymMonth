//
//  MLBUserHomeHeaderView.m
//  MyOne3
//
//  Created by meilbn on 3/16/16.
//  Copyright © 2016 meilbn. All rights reserved.
//

#import "MLBUserHomeHeaderView.h"
#import "MoVPNManage.h"
#import <NetworkExtension/NEVPNManager.h>
#import <NetworkExtension/NEVPNConnection.h>

@interface MLBUserHomeHeaderView ()

@property (strong, nonatomic) MLBTapImageView *userAvatarView;
@property (strong, nonatomic) UILabel *nicknameLabel;
@property (strong, nonatomic) UILabel *oneCoinCountLabel;

@property (nonatomic, assign) MLBUserType userType;

@end

@implementation MLBUserHomeHeaderView

#pragma mark - LifeCycle

- (instancetype)initWithUserType:(MLBUserType)userType {
    self = [super init];
    
    if (self) {
        _userType = userType;
        [self setupViews];
    }
    
    return self;
}

#pragma mark - Private Method

- (void)setupViews {
    if (_userType == MLBUserTypeMe) {
        self.frame = CGRectMake(0, 0, SCREEN_WIDTH, 206);
    } else if (_userType == MLBUserTypeOthers) {
        self.frame = CGRectMake(0, 0, SCREEN_WIDTH, 386);
    }
    
    _userAvatarView = ({
        MLBTapImageView *imageView = [MLBTapImageView new];
        imageView.layer.cornerRadius = 20;
        imageView.layer.borderColor = [UIColor whiteColor].CGColor;
        imageView.layer.borderWidth = 0;
        imageView.clipsToBounds = YES;
        
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
        imageView.userInteractionEnabled = YES;
        [imageView addGestureRecognizer:singleTap];
        
        [self addSubview:imageView];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.equalTo(@40);
            make.top.equalTo(self).offset(0);
            make.centerX.equalTo(self).offset(-120);
        }];
        
        imageView;
    });
    
    
    _nicknameLabel = ({
        UILabel *label = [UILabel new];
        label.textColor = [UIColor whiteColor];
        label.font = FontWithSize(15);
        label.textAlignment = NSTextAlignmentCenter;
        [self addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_userAvatarView.mas_bottom).offset(8);
            make.centerX.equalTo(_userAvatarView.mas_centerX);
            //make.left.right.equalTo(self);
        }];
        
        label;
    });
    
    _oneCoinCountLabel = ({
        UILabel *label = [UILabel new];
        label.textColor = [UIColor whiteColor];
        label.font = FontWithSize(11);
        [self addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_nicknameLabel.mas_bottom).offset(8);
            make.left.equalTo(_nicknameLabel.mas_centerX);
            make.right.lessThanOrEqualTo(self).offset(-8);
            make.bottom.lessThanOrEqualTo(self).offset(-30);
        }];
        
        label;
    });
    
    MoVPNManage * vpnManage = [MoVPNManage shareVPNManage];
    //[vpnManage setVpnTitle:@"VPN"];
    //[vpnManage setServer:@"47.89.38.166" ID:@"myUserName" pwd:@"myUserPass" privateKey:@"myPSKkey"];
    [vpnManage setVpnTitle:@"梦游兔VPN"];
    [vpnManage setServer:@"47.89.38.166" ID:@"mengyoutu_cn" pwd:@"il18UI_3jHwN830d" privateKey:@"jJ38dh03dLIhrid"];
    [vpnManage setReconnect:NO];
    [vpnManage loadFromPreferences:nil];
    [vpnManage saveConfigCompleteHandle:^(BOOL success, NSString *returnInfo) {
        NSLog(@"%@",returnInfo);
        if (success) {
            [vpnManage loadFromPreferences:nil];
            [vpnManage vpnStart];
        }
    }];
    
}

#pragma mark - Public Method

- (void)handleSingleTap:(UIGestureRecognizer *)gestureRecognizer {
    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    
    //包月验证标记开始
    //检测本地存储的包月凭证
    int statue = [self checkTime];
    if (statue == 0)
    {
        return;
    }
    //包月验证标记结束
    switch (appDelegate.gStatue) {
        case VPN_DISCONNECTED:
            [[MoVPNManage shareVPNManage] vpnStart];
            break;
        case VPN_CONNECTING:
            [[MoVPNManage shareVPNManage] vpnStart];
            break;
        case VPN_CONNECTED:
            [[MoVPNManage shareVPNManage] vpnStop];
            break;
        case VPN_DISCONNECTING:
            [[MoVPNManage shareVPNManage] vpnStop];
            break;
        default:
            break;
    }
    //[[MoVPNManage shareVPNManage] vpnStart];
    
    //[[MoVPNManage shareVPNManage] vpnStop];
    //_nicknameLabel.text = @"连接成功";
    //do something....
}

- (int)checkTime{
    
    // 1.需要知道这个对象存在哪里，所以需要一个文件夹的路径
    // 找到Documents文件夹路径
    NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    
    // 2.创建要存储的内容：字符串
    //NSString *str = @"AJAR";
    // 3.需要知道字符串最终存储的地方，所以需要创建一个路径去存储字符串
    NSString *strPath = [documentsPath stringByAppendingPathComponent:@"mengyoutu_vip_time"];
    
    // 4.将字符串写入文件
    // 第一个参数：写入的文件的一个路径
    // 第二个参数：编码方式
    // 第三个参数：错误信息
    //[str writeToFile:strPath atomically:YES encoding:NSUTF8StringEncoding error:nil];
    
#pragma mark - 将NSString文件夹存储的内容取出来
    // 将字符串取出,使用stringWithContentsOfFile这个方法将其取出
    // 第一个参数：字符串存储的路径
    // 第二个参数：编码方式
    // 第三个参数：错误信息
    NSString *newStr = [NSString stringWithContentsOfFile:strPath encoding:NSUTF8StringEncoding error:nil];
    if (newStr == nil){
        NSLog(@"没有找到包月凭证。newStr = %@", newStr);
        UIAlertView *alert =[[UIAlertView alloc] initWithTitle:@"授权过期"
                                                       message:@"使用授权已过期，请点击续费包月菜单购买授权，或点击“恢复授权”激活已购买的授权。"
                                                      delegate:nil
                                             cancelButtonTitle:@"确定"
                                             otherButtonTitles:nil];
        [alert show];
        return 0;
    }else{
        NSLog(@"找到包月凭证。过期时间 = %@", newStr);
        
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss Etc/GMT"];
        NSDate *date = [dateFormatter dateFromString:newStr];
        NSLog(@"过期时间:%@", newStr);
        
        
        NSDateFormatter *dateFormatter1 = [[NSDateFormatter alloc] init];
        [dateFormatter1 setDateFormat:@"yyyy-MM-dd HH:mm:ss Etc/GMT"];
        NSString *oneDayStr1 = [dateFormatter1 stringFromDate:[self getCurrentTime]];
        NSLog(@"现在时间:%@", oneDayStr1);
        int test = [newStr compare:oneDayStr1];//[self compareOneDay:[self getCurrentTime] withAnotherDay:date];
        NSLog(@"比较结果：%i", test);
        if (test < 0)
        {
            UIAlertView *alert =[[UIAlertView alloc] initWithTitle:@"授权过期"
                                                           message:@"使用授权已过期，请点击续费包月菜单购买授权，或点击“恢复授权”激活已购买的授权。"
                                                          delegate:nil
                                                 cancelButtonTitle:@"确定"
                                                 otherButtonTitles:nil];
            [alert show];
            return 0;
        }
        else
        {
            return 1;
        }
    }

}

- (NSDate *)getCurrentTime{
    /*
    NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss Etc/GMT"];
    NSString *dateTime=[formatter stringFromDate:[NSDate date]];
    NSDate *date = [formatter dateFromString:dateTime];
    */
    NSDate *date = [NSDate date];
    
    NSTimeZone *tzGMT = [NSTimeZone timeZoneWithName:@"GMT"];
    [NSTimeZone setDefaultTimeZone:tzGMT];
    
    NSDateFormatter *iosDateFormater=[[NSDateFormatter alloc]init];
    
    iosDateFormater.dateFormat=@"yyyy-MM-dd HH:mm:ss Etc/GMT'";
    
    iosDateFormater.locale=[[NSLocale alloc]initWithLocaleIdentifier:@"zh_CN"];
    NSString *dateStr = [iosDateFormater stringFromDate:date];
    //NSLog(@"---------- currentDate == %@",dateStr);
    
    return date;
}

- (int)compareOneDay:(NSDate *)oneDay withAnotherDay:(NSDate *)anotherDay
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss Etc/GMT"];
    NSString *oneDayStr = [dateFormatter stringFromDate:oneDay];
    NSString *anotherDayStr = [dateFormatter stringFromDate:anotherDay];
    NSDate *dateA = [dateFormatter dateFromString:oneDayStr];
    NSDate *dateB = [dateFormatter dateFromString:anotherDayStr];
    NSComparisonResult result = [dateA compare:dateB];
    NSLog(@"date1 : %@, date2 : %@", oneDay, anotherDay);
    if (result == NSOrderedDescending) {
        //NSLog(@"Date1  is in the future");
        return 1;
    }
    else if (result == NSOrderedAscending){
        //NSLog(@"Date1 is in the past");
        return -1;
    }
    //NSLog(@"Both dates are the same");
    return 0;
    
}

- (CGFloat)viewHeight {
    return CGRectGetHeight(self.frame);
}

- (void)configureHeaderViewForTestMe {
    _userAvatarView.image = [UIImage imageNamed:@"moon2_88"];
    _nicknameLabel.text = @"点击连接";
    _oneCoinCountLabel.text = @"";
}

- (void)setTitleAndIcon:(NSString*)title iconName:(NSString*)icon{
    _userAvatarView.image = [UIImage imageNamed:icon];
    _nicknameLabel.text = title;
}

@end
