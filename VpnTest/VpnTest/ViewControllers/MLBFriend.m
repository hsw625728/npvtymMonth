//
//  MLBSettingsViewController.m
//  MyOne3
//
//  Created by meilbn on 3/16/16.
//  Copyright © 2016 meilbn. All rights reserved.
//

#import "MLBFriend.h"
#import "MLBSettingsSectionHeaderView.h"
#import "MLBSettingsCell.h"

@interface MLBFriendViewController () <UITableViewDataSource, UITableViewDelegate>


@property (strong, nonatomic) UITableView *tableView;

@end

@implementation MLBFriendViewController {
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
    self.title = @"邀请好友";
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
    dataSource = @[@[@"邀请好友", @[@"点击发送邀请"]]];
    
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
    
    if (indexPath.section == 0 && indexPath.row == 0) {// 流量播放提醒
        cell = [tableView dequeueReusableCellWithIdentifier:kSettingsCellIDWithSwitch forIndexPath:indexPath];
        [cell configureCellWithTitle:rowTitle isSwitchOn:[[UserDefaults objectForKey:MLBNetworkFlowRemindKey] isEqualToString:@"YES"]];
        __weak typeof(self) weakSelf = self;
        cell.switchChanged = ^(BOOL isOn) {
            __strong typeof(weakSelf) strongSelf = weakSelf;
            [strongSelf networkFlowRemindSwitchDidChanged:isOn];
        };
    } else if (indexPath.section == 1 && indexPath.row == 4) {// 版本号
        cell = [tableView dequeueReusableCellWithIdentifier:kSettingsCellIDWithVerison forIndexPath:indexPath];
        [cell configureCellWithTitle:rowTitle version:version];
    } else {
        cell = [tableView dequeueReusableCellWithIdentifier:kSettingsCellIDWithArrow forIndexPath:indexPath];
        [cell configureCellWithTitle:rowTitle];
    }
    
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
}

- (void)DoneClick
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
