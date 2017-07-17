//
//  MLBUserHomeViewController.m
//  MyOne3
//
//  Created by meilbn on 3/16/16.
//  Copyright © 2016 meilbn. All rights reserved.
//

#import "MLBUserHomeViewController.h"
#import "ParallaxHeaderView.h"
#import "MLBBaseViewController.h"
#import "MLBUserHomeCell.h"
#import "MLBUserHomeHeaderView.h"
#import "MLBSettingsSectionHeaderView.h"
#import "MLBSettingsViewController.h"
#import "MLBContent.h"
#import "MLBHelp.h"
#import "MLBRepire.h"
#import "MLBAppList.h"
#import "MLBFriend.h"
#import "MLBIAP.h"
//分享功能
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>

@interface MLBUserHomeViewController () <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) MLBUserHomeHeaderView *headerView;
@property (strong, nonatomic) UIImageView *headerImageViewMoon;
@property (strong, nonatomic) ParallaxHeaderView *parallaxHeaderViewMoon;
@property (strong, nonatomic) UIImageView *headerImageViewSun;
@property (strong, nonatomic) ParallaxHeaderView *parallaxHeaderViewSun;

- (void)shareMeToYourFriends;
- (void)shareToWeixin;
- (void)shareToWeixinTimeline;
- (void)shareToQQ;
- (void)shareToWeibo;
- (void)shareToMail;
- (void)shareToSMS;

@end

@implementation MLBUserHomeViewController {
    NSArray *sectionTitles;
    NSArray *rowTitles;
    NSArray *rowImageNames;
}

#pragma mark - Lifecycle

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - View Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //self.hideNavigationBar = YES;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.edgesForExtendedLayout = UIRectEdgeAll;
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:[UIColor clearColor]] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    
    [self initDatas];
    [self setupViews];
}

#pragma mark - Private Method

- (void)initDatas {
    sectionTitles = @[@"包月计划", @"帮助说明", @"支持梦游兔", @"关于梦游兔"];
    rowTitles = @[@[@"续费包月"], @[@"帮助说明",@"故障排除"], @[@"App列表"], @[@"联系梦游兔", @"分享给朋友"]];
    rowImageNames = @[@[@"nav_music_libraries_highlighted"], @[@"center_setting", @"tab_read_normal"], @[@"tab_home_normal"], @[@"center_setting", /*@"tab_home_normal", */@"nav_me_normal"]];
}

- (void)setupViews {
    _headerView = [[MLBUserHomeHeaderView alloc] initWithUserType:MLBUserTypeMe];
    [_headerView configureHeaderViewForTestMe];
    
    
    
    
    //设置太阳表头背景
    _headerImageViewSun = [[UIImageView alloc] initWithImage:[UIImage mlb_imageWithName:@"middle_full" cached:NO]];
    _headerImageViewSun.frame = CGRectMake(0, 0, SCREEN_WIDTH, 256);
    _headerImageViewSun.contentMode = UIViewContentModeScaleAspectFill;
    _parallaxHeaderViewSun = [ParallaxHeaderView parallaxHeaderViewWithSubView:_headerImageViewSun];
    
    [_parallaxHeaderViewSun addSubview:_headerView];
    [_headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@([_headerView viewHeight]));
        make.left.bottom.right.equalTo(_parallaxHeaderViewSun);
    }];
    
    //设置月亮表头背景
    _headerImageViewMoon = [[UIImageView alloc] initWithImage:[UIImage mlb_imageWithName:@"middle_night_full" cached:NO]];
    _headerImageViewMoon.frame = CGRectMake(0, 0, SCREEN_WIDTH, 256);
    _headerImageViewMoon.contentMode = UIViewContentModeScaleAspectFill;
    _parallaxHeaderViewMoon = [ParallaxHeaderView parallaxHeaderViewWithSubView:_headerImageViewMoon];
    
    [_parallaxHeaderViewMoon addSubview:_headerView];
    [_headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@([_headerView viewHeight]));
        make.left.bottom.right.equalTo(_parallaxHeaderViewMoon);
    }];
    
    _tableView = ({
        UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
        tableView.backgroundColor = MLBViewControllerBGColor;
        tableView.dataSource = self;
        tableView.delegate = self;
        [tableView registerClass:[MLBUserHomeCell class] forCellReuseIdentifier:kUserHomeCellID];
        [tableView registerClass:[MLBSettingsSectionHeaderView class] forHeaderFooterViewReuseIdentifier:kSettingsSectionHeaderViewID];
        tableView.rowHeight = [MLBUserHomeCell cellHeight];
        
        
        tableView.tableHeaderView = _parallaxHeaderViewMoon;
        [self.view addSubview:tableView];
        [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
        
        tableView;
    });
}

#pragma mark - Public Method



#pragma mark - Action



#pragma mark - Network Request



#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [(ParallaxHeaderView *)_tableView.tableHeaderView layoutHeaderViewForScrollViewOffset:scrollView.contentOffset];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return sectionTitles.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *rows = rowTitles[section];
    return rows.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MLBUserHomeCell *cell = [tableView dequeueReusableCellWithIdentifier:kUserHomeCellID forIndexPath:indexPath];
    [cell configureCellWithTitle:rowTitles[indexPath.section][indexPath.row] imageName:rowImageNames[indexPath.section][indexPath.row] atIndexPath:indexPath];
    
    return cell;
}

#pragma mark UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return [MLBSettingsSectionHeaderView viewHeight];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    MLBSettingsSectionHeaderView *view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:kSettingsSectionHeaderViewID];
    view.titleLabel.text = sectionTitles[section];
    
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 10;
}


//sectionTitles = @[@"帮助说明", @"支持梦游兔", @"关于梦游兔"];
//rowTitles = @[@[@"帮助说明",@"故障排除"], @[@"App列表"], @[@"联系梦游兔", @"分享给朋友"]];

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UINavigationController *nav = nil;
    
    if (indexPath.section == 0 && indexPath.row == 0)
    {
        nav = [[UINavigationController alloc] initWithRootViewController:[[MLBIAPViewController alloc] init]];
        [nav setModalTransitionStyle:UIModalTransitionStyleFlipHorizontal];
        [self presentViewController:nav animated:YES completion:NULL];
    }
    else if (indexPath.section == 1 && indexPath.row == 0)
    {
        nav = [[UINavigationController alloc] initWithRootViewController:[[MLBHelpViewController alloc] init]];
        [nav setModalTransitionStyle:UIModalTransitionStyleFlipHorizontal];
        [self presentViewController:nav animated:YES completion:NULL];
    }
    else if (indexPath.section == 1 && indexPath.row == 1)
    {
        nav = [[UINavigationController alloc] initWithRootViewController:[[MLBRepireViewController alloc] init]];
        [nav setModalTransitionStyle:UIModalTransitionStyleFlipHorizontal];
        [self presentViewController:nav animated:YES completion:NULL];
    }
    else if (indexPath.section == 2 && indexPath.row == 0)
    {
        nav = [[UINavigationController alloc] initWithRootViewController:[[MLBAppListViewController alloc] init]];
        [nav setModalTransitionStyle:UIModalTransitionStyleFlipHorizontal];
        [self presentViewController:nav animated:YES completion:NULL];
    }
    else if (indexPath.section == 2 && indexPath.row == 2)
    {
        nav = [[UINavigationController alloc] initWithRootViewController:[[MLBSettingsViewController alloc] init]];
        [nav setModalTransitionStyle:UIModalTransitionStyleFlipHorizontal];
        [self presentViewController:nav animated:YES completion:NULL];
    }
    else if (indexPath.section == 3 && indexPath.row == 0)
    {
        nav = [[UINavigationController alloc] initWithRootViewController:[[MLBContentViewController alloc] init]];
        [nav setModalTransitionStyle:UIModalTransitionStyleFlipHorizontal];
        [self presentViewController:nav animated:YES completion:NULL];
    }
    else if (indexPath.section == 3 && indexPath.row == 1)
    {
        //nav = [[UINavigationController alloc] initWithRootViewController:[[MLBContentViewController alloc] init]];
        //分享给朋友
        //1、创建分享参数
        /*
        NSArray* imageArray = @[[UIImage imageNamed:@"share_QR.png"]];
        //（注意：图片必须要在Xcode左边目录里面，名称必须要传正确，如果要分享网络图片，可以这样传iamge参数 images:@[@"http://mob.com/Assets/images/logo.png?v=20150320"]）
        if (imageArray) {
            
            NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
            [shareParams SSDKSetupShareParamsByText:@"给你推荐一个高速稳定的VPN，一键连接，高速稳定。让你上Facebook、YouTube、Google、Gmail、Instagram、Pinterest......给你带来前所未有翱翔世界的快感！"
                                             images:imageArray
                                                url:[NSURL URLWithString:@"https://itunes.apple.com/us/app/id1220366660?l=zh&ls=1&mt=8"]
                                              title:@"强烈推荐"
                                               type:SSDKContentTypeAuto];
            //2、分享（可以弹出我们的分享菜单和编辑界面）
            //要显示菜单的视图, iPad版中此参数作为弹出菜单的参照视图，只有传这个才可以弹出我们的分享菜单，可以传分享的按钮对象或者自己创建小的view 对象，iPhone可以传nil不会影响
            [ShareSDK showShareActionSheet:nil items:nil
                               shareParams:shareParams
                       onShareStateChanged:^(SSDKResponseState state, SSDKPlatformType platformType, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error, BOOL end)
            {
                           
                           switch (state)
                           {
                               case SSDKResponseStateSuccess:
                               {
                                   UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享成功"
                                                                                       message:nil
                                                                                      delegate:nil
                                                                             cancelButtonTitle:@"确定"
                                                                             otherButtonTitles:nil];
                                   [alertView show];
                                   break;
                               }
                               case SSDKResponseStateFail:
                               {
                                   UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"分享失败"
                                                                                   message:[NSString stringWithFormat:@"%@",error]
                                                                                  delegate:nil
                                                                         cancelButtonTitle:@"OK"
                                                                         otherButtonTitles:nil, nil];
                                   [alert show];
                                   break;
                               }
                               default:
                                   break;
                           }
            }];
        }
         */
        [self shareMeToYourFriends];
    }
    //[self.navigationController pushViewController:nav animated:YES];
}

- (void)updateTitleAndIcon:(NSString*)title iconName:(NSString*)icon{
    [_headerView setTitleAndIcon:title iconName:icon];
    if (![title isEqualToString:@"VPN已连接"])
    {
        [_parallaxHeaderViewMoon addSubview:_headerView];
        [_headerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@([_headerView viewHeight]));
            make.left.bottom.right.equalTo(_parallaxHeaderViewMoon);
        }];
        _tableView.tableHeaderView = _parallaxHeaderViewMoon;
    }
    else
    {
        [_parallaxHeaderViewSun addSubview:_headerView];
        [_headerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@([_headerView viewHeight]));
            make.left.bottom.right.equalTo(_parallaxHeaderViewSun);
        }];
        _tableView.tableHeaderView = _parallaxHeaderViewSun;
    }
}

- (void)shareMeToYourFriends{
    [self showPopMenuViewWithMenuSelectedBlock:^(MLBPopMenuType menuType) {

        //分享平台选择
        switch(menuType){
            case MLBPopMenuTypeWechatFrined:
                [self shareToWeixin];
                break;
            case MLBPopMenuTypeMoments:
                [self shareToWeixinTimeline];
                break;/*
            case MLBPopMenuTypeWeibo:
                [self shareToWeibo];
                break;*/
            case MLBPopMenuTypeQQ:
                [self shareToQQ];
                break;
            case MLBPopMenuTypeMail:
                [self shareToMail];
                break;
            case MLBPopMenuTypeSMS:
                [self shareToSMS];
                break;
            default:
                return;
                break;
        }
    }];
}


- (void)shareToWeixin{
        //参数设定
        NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
        [shareParams SSDKSetupWeChatParamsByText:@"🍌一键连接    🍎界面简洁\n🍊稳定高速    🍉不限流量\n➡️➡️点击进入下载页面⬅️⬅️"
                                           title:@"[App推荐]稳定好用的VPN"
                                             url:[NSURL URLWithString:@"https://itunes.apple.com/us/app/id1220366660?l=zh&ls=1&mt=8"]
                                      thumbImage:[UIImage imageNamed:@"Icon108.png"]
                                           image:[UIImage imageNamed:@"share_QR.png"]
                                    musicFileURL:nil
                                         extInfo:nil
                                        fileData:nil
                                    emoticonData:nil
                                            type:SSDKContentTypeApp
                              forPlatformSubType:SSDKPlatformSubTypeWechatSession];
        
        //分享事件
        [ShareSDK share:SSDKPlatformSubTypeWechatSession parameters:shareParams
         onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error)
         {
             // 回调处理....
             switch (state)
             {
                 case SSDKResponseStateSuccess:
                 {
                     UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享成功"
                                                                         message:@"🐰谢谢您的分享🐰"
                                                                        delegate:nil
                                                               cancelButtonTitle:@"确定"
                                                               otherButtonTitles:nil];
                     [alertView show];
                     break;
                 }
                 case SSDKResponseStateFail:
                 {
                     UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"分享失败"
                                                                     message:[NSString stringWithFormat:@"%@",error]
                                                                    delegate:nil
                                                           cancelButtonTitle:@"OK"
                                                           otherButtonTitles:nil, nil];
                     [alert show];
                     break;
                 }
                 default:
                     break;
             }
         }];
}

- (void)shareToWeixinTimeline{
    
        NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
        
        [shareParams SSDKSetupWeChatParamsByText:@"🍌一键连接    🍎界面简洁\n🍊稳定高速    🍉不限流量\n➡️➡️点击进入下载页面⬅️⬅️"
                                           title:@"[App推荐]稳定好用的VPN"
                                             url:[NSURL URLWithString:@"https://itunes.apple.com/us/app/id1220366660?l=zh&ls=1&mt=8"]
                                      thumbImage:[UIImage imageNamed:@"Icon108.png"]
                                           image:[UIImage imageNamed:@"share_QR.png"]
                                    musicFileURL:nil
                                         extInfo:nil
                                        fileData:nil
                                    emoticonData:nil
                                            type:SSDKContentTypeImage
                              forPlatformSubType:SSDKPlatformSubTypeWechatTimeline];
        
        //分享事件
        [ShareSDK share:SSDKPlatformSubTypeWechatTimeline parameters:shareParams
         onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error)
         {
             // 回调处理....
             switch (state)
             {
                 case SSDKResponseStateSuccess:
                 {
                     UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享成功"
                                                                         message:@"🐰谢谢您的分享🐰"
                                                                        delegate:nil
                                                               cancelButtonTitle:@"确定"
                                                               otherButtonTitles:nil];
                     [alertView show];
                     break;
                 }
                 case SSDKResponseStateFail:
                 {
                     UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"分享失败"
                                                                     message:[NSString stringWithFormat:@"%@",error]
                                                                    delegate:nil
                                                           cancelButtonTitle:@"OK"
                                                           otherButtonTitles:nil, nil];
                     [alert show];
                     break;
                 }
                 default:
                     break;
             }
         }];
}

- (void)shareToQQ{
    
        NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
        [shareParams SSDKSetupQQParamsByText:@"🍌一键连接    🍎界面简洁\n🍊稳定高速    🍉不限流量\n➡️➡️点击进入下载页面⬅️⬅️"
                                       title:@"[App推荐]稳定好用的VPN"
                                         url:[NSURL URLWithString:@"https://itunes.apple.com/us/app/id1220366660?l=zh&ls=1&mt=8"]
                                  thumbImage:[UIImage imageNamed:@"Icon108.png"]
                                       image:[UIImage imageNamed:@"share_QR.png"]
                                        type:SSDKContentTypeImage
                          forPlatformSubType:SSDKPlatformSubTypeQQFriend];
        
        //分享事件
        [ShareSDK share:SSDKPlatformSubTypeQQFriend parameters:shareParams
         onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error)
         {
             // 回调处理....
             switch (state)
             {
                 case SSDKResponseStateSuccess:
                 {
                     UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享成功"
                                                                         message:@"🐰谢谢您的分享🐰"
                                                                        delegate:nil
                                                               cancelButtonTitle:@"确定"
                                                               otherButtonTitles:nil];
                     [alertView show];
                     break;
                 }
                 case SSDKResponseStateFail:
                 {
                     UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"分享失败"
                                                                     message:[NSString stringWithFormat:@"%@",error]
                                                                    delegate:nil
                                                           cancelButtonTitle:@"OK"
                                                           otherButtonTitles:nil, nil];
                     [alert show];
                     break;
                 }
                 default:
                     break;
             }
         }];
    
}

- (void)shareToWeibo{
    
        NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
        [shareParams SSDKSetupSinaWeiboShareParamsByText:@"🍌一键连接    🍎界面简洁\n🍊稳定高速    🍉不限流量\n➡️➡️点击进入下载页面⬅️⬅️"
                                                   title:@"[App推荐]稳定好用的VPN"
                                                   image:[UIImage imageNamed:@"share_QR.png"]
                                                     url:[NSURL URLWithString:@"https://itunes.apple.com/us/app/id1220366660?l=zh&ls=1&mt=8"]
                                                latitude:0
                                               longitude:0
                                                objectID:nil
                                                    type:SSDKContentTypeAuto];
        

        //分享事件
        [ShareSDK share:SSDKPlatformTypeSinaWeibo parameters:shareParams
         onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error)
         {
             // 回调处理....
             switch (state)
             {
                 case SSDKResponseStateSuccess:
                 {
                     UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享成功"
                                                                         message:@"🐰谢谢您的分享🐰"
                                                                        delegate:nil
                                                               cancelButtonTitle:@"确定"
                                                               otherButtonTitles:nil];
                     [alertView show];
                     break;
                 }
                 case SSDKResponseStateFail:
                 {
                     UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"分享失败"
                                                                     message:[NSString stringWithFormat:@"%@",error]
                                                                    delegate:nil
                                                           cancelButtonTitle:@"OK"
                                                           otherButtonTitles:nil, nil];
                     [alert show];
                     break;
                 }
                 default:
                     break;
             }
         }];
}

- (void)shareToMail{
    
        NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
        [shareParams SSDKSetupShareParamsByText:@"给你推荐一个苹果手机上使用的VPN软件 \n🍌一键连接    🍎界面简洁\n🍊稳定高速    🍉不限流量\n➡️➡️点击进入下载页面⬅️⬅️"
                                         images:[UIImage imageNamed:@"share_QR.png"]
                                            url:[NSURL URLWithString:@"https://itunes.apple.com/us/app/id1220366660?l=zh&ls=1&mt=8"]
                                          title:@"[App推荐]稳定好用的VPN"
                                           type:SSDKContentTypeAuto];
        
        //分享事件
        [ShareSDK share:SSDKPlatformTypeMail parameters:shareParams
         onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error)
         {
             // 回调处理....
             switch (state)
             {
                 case SSDKResponseStateSuccess:
                 {
                     UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享成功"
                                                                         message:@"🐰谢谢您的分享🐰"
                                                                        delegate:nil
                                                               cancelButtonTitle:@"确定"
                                                               otherButtonTitles:nil];
                     [alertView show];
                     break;
                 }
                 case SSDKResponseStateFail:
                 {
                     UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"分享失败"
                                                                     message:[NSString stringWithFormat:@"%@",error]
                                                                    delegate:nil
                                                           cancelButtonTitle:@"OK"
                                                           otherButtonTitles:nil, nil];
                     [alert show];
                     break;
                 }
                 default:
                     break;
             }
         }];
}

- (void)shareToSMS{
    
        NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
        [shareParams SSDKSetupShareParamsByText:@"给你推荐一个苹果手机上使用的VPN软件 \n🍌一键连接    🍎界面简洁\n🍊稳定高速    🍉不限流量\n➡️➡️点击进入下载页面⬅️⬅️"
                                         images:[UIImage imageNamed:@"share_QR.png"]
                                            url:[NSURL URLWithString:@"https://itunes.apple.com/us/app/id1220366660?l=zh&ls=1&mt=8"]
                                          title:@"[App推荐]稳定好用的VPN"
                                           type:SSDKContentTypeAuto];
        
        //分享事件
        [ShareSDK share:SSDKPlatformTypeSMS parameters:shareParams
         onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error)
         {
             // 回调处理....
             switch (state)
             {
                 case SSDKResponseStateSuccess:
                 {
                     UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享成功"
                                                                         message:@"🐰谢谢您的分享🐰"
                                                                        delegate:nil
                                                               cancelButtonTitle:@"确定"
                                                               otherButtonTitles:nil];
                     [alertView show];
                     break;
                 }
                 case SSDKResponseStateFail:
                 {
                     UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"分享失败"
                                                                     message:[NSString stringWithFormat:@"%@",error]
                                                                    delegate:nil
                                                           cancelButtonTitle:@"OK"
                                                           otherButtonTitles:nil, nil];
                     [alert show];
                     break;
                 }
                 default:
                     break;
             }
         }];
}

@end
