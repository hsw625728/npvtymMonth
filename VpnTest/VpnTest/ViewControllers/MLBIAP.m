//
//  MLBSettingsViewController.m
//  MyOne3
//
//  Created by meilbn on 3/16/16.
//  Copyright © 2016 meilbn. All rights reserved.
//

#import "MLBIAP.h"
#import "MLBSettingsSectionHeaderView.h"
#import "MLBSettingsCell.h"
#import "IAPShare.h"
#import "IAPHelper.h"

@interface MLBIAPViewController () <UITableViewDataSource, UITableViewDelegate>


@property (strong, nonatomic) UITableView *tableView;

@end

@implementation MLBIAPViewController {
    NSArray *dataSource;
    NSString *version;
    SKProduct* product0;
    SKProduct* product1;
    SKProduct* product2;
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
    self.title = @"续费时长";
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
    dataSource = @[@[@"订阅", @[@"45元订阅一个月", @"268元订阅六个月", @"508元订阅一年"]]];
    
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
//    NSString *prodName = [infoDictionary objectForKey:@"CFBundleName"];
    NSString *majorVersion = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
//    NSString *minorVersion = [infoDictionary objectForKey:@"CFBundleVersion"];
    version = majorVersion;
    
    //IAPHelper
    if(![IAPShare sharedHelper].iap) {
        NSSet* dataSet = [[NSSet alloc] initWithObjects:@"cn.mengyoutu.vpn.month1", @"cn.mengyoutu.vpn.month6", @"cn.mengyoutu.vpn.year1", nil];
        [IAPShare sharedHelper].iap = [[IAPHelper alloc] initWithProductIdentifiers:dataSet];
    }
    //yes为生产环境  no为沙盒测试模式
    // 客户端做收据校验有用  服务器做收据校验忽略...
    [IAPShare sharedHelper].iap.production = NO;
    [[IAPShare sharedHelper].iap requestProductsWithCompletion:^(SKProductsRequest* request,SKProductsResponse* response)
     {
         if(response > 0 ) {
             
             product0 =[[IAPShare sharedHelper].iap.products objectAtIndex:0];
             product1 =[[IAPShare sharedHelper].iap.products objectAtIndex:1];
             product2 =[[IAPShare sharedHelper].iap.products objectAtIndex:2];
             
             
         }
     }];
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

- (void)buyItem:(int)index{
    
    SKProduct* product;
    
    switch(index){
        case 0:
            product = product0;
            break;
        case 1:
            product = product1;
            break;
        case 2:
            product = product2;
            break;
        default:
            break;
    }
    NSLog(@"Price: %@",[[IAPShare sharedHelper].iap getLocalePrice:product]);
    NSLog(@"Title: %@",product.localizedTitle);
    
    [[IAPShare sharedHelper].iap buyProduct:product
                               onCompletion:^(SKPaymentTransaction* trans){
                                   
                                   if(trans.error)
                                   {
                                       NSLog(@"Fail %@",[trans.error localizedDescription]);
                                   }
                                   else if(trans.transactionState == SKPaymentTransactionStatePurchased) {
                                       
                                       [[IAPShare sharedHelper].iap checkReceipt:[NSData dataWithContentsOfURL:[[NSBundle mainBundle] appStoreReceiptURL]] AndSharedSecret:@"your sharesecret" onCompletion:^(NSString *response, NSError *error) {
                                           
                                           //Convert JSON String to NSDictionary
                                           NSDictionary* rec = [IAPShare toJSON:response];
                                           
                                           if([rec[@"status"] integerValue]==0)
                                           {
                                               
                                               [[IAPShare sharedHelper].iap provideContentWithTransaction:trans];
                                               NSLog(@"SUCCESS %@",response);
                                               NSLog(@"Pruchases %@",[IAPShare sharedHelper].iap.purchasedProducts);
                                           }
                                           else {
                                               NSLog(@"Fail");
                                           }
                                       }];
                                   }
                                   else if(trans.transactionState == SKPaymentTransactionStateFailed) {
                                       NSLog(@"Fail");
                                   }
                               }];//end of buy product
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
    
    if (indexPath.section == 0 && indexPath.row == 0) {
        [self buyItem:0];
    } else if (indexPath.section == 0 && indexPath.row == 1) {
        [self buyItem:1];
    } else if (indexPath.section == 0 && indexPath.row == 2) {
        [self buyItem:2];
    }
}

- (void)DoneClick
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
