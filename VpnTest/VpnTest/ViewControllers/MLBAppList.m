//
//  MLBSettingsViewController.m
//  MyOne3
//
//  Created by meilbn on 3/16/16.
//  Copyright © 2016 meilbn. All rights reserved.
//

#import "MLBAppList.h"
#import "MLBSettingsSectionHeaderView.h"
#import "MLBSettingsCell.h"

@interface MLBAppListViewController () <UITableViewDataSource, UITableViewDelegate>


@property (strong, nonatomic) UITableView *tableView;

@end

@implementation MLBAppListViewController {
    NSArray *dataSource;
    NSString *version;
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
    self.title = @"梦游兔的App列表";
    //[self addNavigationBarRightMusicItem];
    
    UIButton *plantButton = [MLBUIFactory buttonWithImageName:@"close_highlighted" highlightImageName:@"close_normal" target:self action:@selector(DoneClick)];
    plantButton.frame = (CGRect){{0, 0}, CGSizeMake(40, 40)};
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:plantButton];
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor]] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:nil];
    
    [self initDatas];
    [self setupViews];
}

#pragma mark - Private Method

- (void)initDatas {
    dataSource = @[@[@"", @[@"点击跳转->《几何大师》⭐️⭐️⭐️⭐️⭐️", @"点击跳转->《粒子大师》⭐️⭐️⭐️⭐️⭐️", @"点击跳转->《马赛克》⭐️", @"点击跳转->《逃离迷宫》⭐️⭐️", @"点击跳转->《毁灭前夕》⭐️⭐️⭐️⭐️", @"点击跳转->《细菌消消乐》⭐️", @"点击跳转->《时间追踪》⭐️⭐️", @"点击跳转->《黑白对战》⭐️", @"点击跳转->《眼疾手快》⭐️⭐️⭐️", @"点击跳转->《康威生命游戏》⭐️⭐️⭐️⭐️", @"点击跳转->《勇者地下城纸牌》⭐️⭐️⭐️⭐️⭐️"]]];
    
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
//    NSString *prodName = [infoDictionary objectForKey:@"CFBundleName"];
    NSString *majorVersion = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
//    NSString *minorVersion = [infoDictionary objectForKey:@"CFBundleVersion"];
    version = majorVersion;
}

- (void)setupViews {
    _tableView = ({
        UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
        tableView.backgroundColor = MLBViewControllerBGColor;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        tableView.dataSource = self;
        tableView.delegate = self;
        tableView.rowHeight = 44;
        [tableView registerClass:[MLBSettingsSectionHeaderView class] forHeaderFooterViewReuseIdentifier:kSettingsSectionHeaderViewID];
        [tableView registerClass:[MLBSettingsCell class] forCellReuseIdentifier:kSettingsCellIDWithSwitch];
        [tableView registerClass:[MLBSettingsCell class] forCellReuseIdentifier:kSettingsCellIDWithArrow];
        [tableView registerClass:[MLBSettingsCell class] forCellReuseIdentifier:kSettingsCellIDWithVerison];
        [self.view addSubview:tableView];
        [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
        
        tableView;
    });
}

#pragma mark - Public Method



#pragma mark - Action

- (void)networkFlowRemindSwitchDidChanged:(BOOL)isOn {
    [UserDefaults setObject:isOn ? @"YES" : @"NO" forKey:MLBNetworkFlowRemindKey];
}

#pragma mark - Network Request



#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return dataSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *items = dataSource[section][1];
    return items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MLBSettingsCell *cell;
    
    NSArray *rowTitles = dataSource[indexPath.section][1];
    NSString *rowTitle = rowTitles[indexPath.row];
    
    cell = [tableView dequeueReusableCellWithIdentifier:kSettingsCellIDWithArrow forIndexPath:indexPath];
    [cell configureCellWithTitle:rowTitle];
    
    return cell;
}

#pragma mark UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return [MLBSettingsSectionHeaderView viewHeight];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    MLBSettingsSectionHeaderView *view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:kSettingsSectionHeaderViewID];
    view.titleLabel.text = dataSource[section][0];
    
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 10;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UINavigationController *nav = nil;
    if (indexPath.section == 0 && indexPath.row == 0)
    {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"itms-apps://itunes.apple.com/cn/app/id1219121149?mt=8"]];
    }
    else if(indexPath.section == 0 && indexPath.row == 1){
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"itms-apps://itunes.apple.com/cn/app/id1219195472?mt=8"]];
    }
    else if(indexPath.section == 0 && indexPath.row == 2){
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"itms-apps://itunes.apple.com/cn/app/id1211586921?mt=8"]];
    }
    else if(indexPath.section == 0 && indexPath.row == 3){
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"itms-apps://itunes.apple.com/cn/app/id1210332688?mt=8"]];
    }
    else if(indexPath.section == 0 && indexPath.row == 4){
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"itms-apps://itunes.apple.com/cn/app/id1214199356?mt=8"]];
    }
    else if(indexPath.section == 0 && indexPath.row == 5){
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"itms-apps://itunes.apple.com/cn/app/id1212221765?mt=8"]];
    }
    else if(indexPath.section == 0 && indexPath.row == 6){
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"itms-apps://itunes.apple.com/cn/app/id1206851661?mt=8"]];
    }
    else if(indexPath.section == 0 && indexPath.row == 7){
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"itms-apps://itunes.apple.com/cn/app/id1208071503?mt=8"]];
    }
    else if(indexPath.section == 0 && indexPath.row == 8){
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"itms-apps://itunes.apple.com/cn/app/id1193134981?mt=8"]];
    }
    else if(indexPath.section == 0 && indexPath.row == 9){
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"itms-apps://itunes.apple.com/cn/app/id1203120986?mt=8"]];
    }
    else if(indexPath.section == 0 && indexPath.row == 10){
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"itms-apps://itunes.apple.com/cn/app/id1205252865?mt=8"]];
    }
}

- (void)DoneClick
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
