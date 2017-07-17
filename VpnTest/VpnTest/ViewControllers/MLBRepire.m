//
//  MLBSettingsViewController.m
//  MyOne3
//
//  Created by meilbn on 3/16/16.
//  Copyright © 2016 meilbn. All rights reserved.
//

#import "MLBRepire.h"
#import "MLBSettingsSectionHeaderView.h"
#import "MLBSettingsCell.h"

@interface MLBRepireViewController () <UITableViewDataSource, UITableViewDelegate>


@property (strong, nonatomic) UITableView *tableView;

@end

@implementation MLBRepireViewController {
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
    self.title = @"故障修复";
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
    dataSource = @[@[@"故障排除步骤", @[@"1.下载安装时会弹出对话框", @"    需要点击Allow选项", @"    如果没有点击请删除重新安装", @"    安装时请选择Allow选项", @"2.打开系统设置->VPN", @"    确保“梦游兔”被选中", @"3.如果在WiFi环境下失败", @"    请关闭WiFi尝试4G环境下连接", @"4.如果还没解决", @"    请给新浪微博“@梦游兔App”留言"]]];
    
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
}

- (void)DoneClick
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
