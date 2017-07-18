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
#import <UIKit/UIKit.h>
#import "NSString+Base64.h"
//#import <Foundation/NSJSONSerialization.h>

@interface MLBIAPViewController () <UITableViewDataSource, UITableViewDelegate>


@property (strong, nonatomic) UITableView *tableView;

@end

@implementation MLBIAPViewController {
    NSArray *dataSource;
    NSString *version;
    SKProduct* product0;
    SKProduct* product1;
    SKProduct* product2;
    UIActivityIndicatorView* activityIndicatorView;
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
    dataSource = @[@[@"订阅", @[@"45元订阅一个月", @"268元订阅六个月", @"508元订阅一年"]], @[@"恢复授权", @[@"恢复授权"]]];
    
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
    
    //网络请求等待动画
    self->activityIndicatorView=[[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(0,0,100,100)];
    self->activityIndicatorView.center=self.view.center;
    [self->activityIndicatorView setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];
    [self->activityIndicatorView setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [self->activityIndicatorView setBackgroundColor:ColorWithRGBA(100, 100, 100, 100)];
    [self.view addSubview:self->activityIndicatorView];
    [self->activityIndicatorView startAnimating];
    
    [[IAPShare sharedHelper].iap requestProductsWithCompletion:^(SKProductsRequest* request,SKProductsResponse* response)
     {
         if(response > 0 ) {
             
             product0 =[[IAPShare sharedHelper].iap.products objectAtIndex:0];
             product1 =[[IAPShare sharedHelper].iap.products objectAtIndex:1];
             product2 =[[IAPShare sharedHelper].iap.products objectAtIndex:2];
             
             NSLog(@"SUCCESS %@",response);
         }
         [self->activityIndicatorView stopAnimating];
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
    
    if (nil == product){
        return ;
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
                                       /*
                                       //收据整理上传服务器
                                       // 这个 receipt 就是内购成功 苹果返回的收据
                                       NSData *receipt = [NSData dataWithContentsOfURL:[[NSBundle mainBundle] appStoreReceiptURL]];
                                       
                                       
                                       
                                       //******这里我将receipt base64加密，把加密的收据 和 产品id，一起发送到app服务器********
                                       NSString *receiptBase64 = [NSString base64StringFromData:receipt length:[receipt length]];
                                       
                                       //上传服务器
                                       //[self sendCheckReceiptWithBase64:receiptBase64 productID:product.productIdentifier];
                                       NSString *idfv = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
                                       NSString *post = [NSString stringWithFormat:@"deviceID=%@&record=%@",idfv, receiptBase64];
                                       
                                       NSData *postData = [post dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
                                       
                                       NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[postData length]];
                                       NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
                                       [request setURL:[NSURL URLWithString:@"http://mengyoutu.cn/npvtymmonth/vpnmonthrecord.php"]];
                                       [request setHTTPMethod:@"POST"];
                                       [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
                                       [request setValue:@"application/x-www-form-urlencoded;charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
                                       [request setHTTPBody:postData];
                                       
                                       NSURLResponse *response;
                                       NSData *POSTReply = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:nil];
                                       NSString *theReply = [[NSString alloc] initWithBytes:[POSTReply bytes] length:[POSTReply length] encoding: NSASCIIStringEncoding];
                                       NSLog(@"& API  | %@", theReply);
                                       
                                       */
                                       //收据上传服务器完毕
                                       // 本地验证
                                       [[IAPShare sharedHelper].iap checkReceipt:[NSData dataWithContentsOfURL:[[NSBundle mainBundle] appStoreReceiptURL]] AndSharedSecret:@"0013c2deada24497a5a699390d7ca25a" onCompletion:^(NSString *response, NSError *error) {
                                           
                                           //Convert JSON String to NSDictionary
                                           NSDictionary* rec = [IAPShare toJSON:response];
                                           
                                           if([rec[@"status"] integerValue]==0)
                                           {
                                               
                                               [[IAPShare sharedHelper].iap provideContentWithTransaction:trans];
                                               //NSLog(@"SUCCESS %@",response);
                                               NSLog(@"Pruchases %@",[IAPShare sharedHelper].iap.purchasedProducts);
                                               
                                               //包月验证标记开始
                                               //写入本地存储的包月凭证
                                               // 1.需要知道这个对象存在哪里，所以需要一个文件夹的路径
                                               // 找到Documents文件夹路径
                                               NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
                                               
                                               // 2.创建要存储的内容：字符串
                                               NSString *str = [self parseExpiresDate:response];//@"这里以后填写到期时间等信息";
                                               NSLog(@"ExpriesTime %@",str);
                                               // 3.需要知道字符串最终存储的地方，所以需要创建一个路径去存储字符串
                                               NSString *strPath = [documentsPath stringByAppendingPathComponent:@"mengyoutu_vip_time"];
                                               
                                               // 4.将字符串写入文件
                                               // 第一个参数：写入的文件的一个路径
                                               // 第二个参数：编码方式
                                               // 第三个参数：错误信息
                                               [str writeToFile:strPath atomically:YES encoding:NSUTF8StringEncoding error:nil];
                                               //包月验证标记结束
                                           }
                                           else {
                                               NSLog(@"CheckFail");
                                           }
                                       }];
                                       //本地验证结束
                                   }
                                   else if(trans.transactionState == SKPaymentTransactionStateFailed) {
                                       NSLog(@"StateFail");
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
    } else {
        [[IAPShare sharedHelper].iap restoreProductsWithCompletion:^(SKPaymentQueue *payment, NSError *error) {
            
            //check with SKPaymentQueue
            
            // number of restore count
            int numberOfTransactions = payment.transactions.count;
            
            for (SKPaymentTransaction *transaction in payment.transactions)
            {
                NSString *purchased = transaction.payment.productIdentifier;
                //if([purchased isEqualToString:@"cn.mengyoutu.vpn.month1"])
                {
                    //enable the prodcut here
                    NSLog(@"授权回复成功%@", purchased);
                    
                    //包月验证标记开始
                    //写入本地存储的包月凭证
                    // 1.需要知道这个对象存在哪里，所以需要一个文件夹的路径
                    // 找到Documents文件夹路径
                    NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
                    
                    // 2.创建要存储的内容：字符串
                    NSString *str = @"这里以后填写到期时间等信息";
                    // 3.需要知道字符串最终存储的地方，所以需要创建一个路径去存储字符串
                    NSString *strPath = [documentsPath stringByAppendingPathComponent:@"mengyoutu_vip_time"];
                    
                    // 4.将字符串写入文件
                    // 第一个参数：写入的文件的一个路径
                    // 第二个参数：编码方式
                    // 第三个参数：错误信息
                    [str writeToFile:strPath atomically:YES encoding:NSUTF8StringEncoding error:nil];
                    //包月验证标记结束
                    
                    [[IAPShare sharedHelper].iap checkReceipt:[NSData dataWithContentsOfURL:[[NSBundle mainBundle] appStoreReceiptURL]] AndSharedSecret:@"0013c2deada24497a5a699390d7ca25a" onCompletion:^(NSString *response, NSError *error) {
                        
                        //Convert JSON String to NSDictionary
                        NSDictionary* rec = [IAPShare toJSON:response];
                        
                        if([rec[@"status"] integerValue]==0)
                        {
                            
                            //[[IAPShare sharedHelper].iap provideContentWithTransaction:trans];
                            //NSLog(@"SUCCESS %@",response);
                            NSLog(@"Pruchases %@",[IAPShare sharedHelper].iap.purchasedProducts);
                            
                            //包月验证标记开始
                            //写入本地存储的包月凭证
                            // 1.需要知道这个对象存在哪里，所以需要一个文件夹的路径
                            // 找到Documents文件夹路径
                            NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
                            
                            // 2.创建要存储的内容：字符串
                            
                            NSString *str = [self parseExpiresDate:response];//@"这里以后填写到期时间等信息";
                            NSLog(@"ExpriesTime %@",str);
                            // 3.需要知道字符串最终存储的地方，所以需要创建一个路径去存储字符串
                            NSString *strPath = [documentsPath stringByAppendingPathComponent:@"mengyoutu_vip_time"];
                            
                            // 4.将字符串写入文件
                            // 第一个参数：写入的文件的一个路径
                            // 第二个参数：编码方式
                            // 第三个参数：错误信息
                            [str writeToFile:strPath atomically:YES encoding:NSUTF8StringEncoding error:nil];
                            //包月验证标记结束
                        }
                        else {
                            NSLog(@"CheckFail:%li", [rec[@"status"] integerValue]);
                        }
                    }];
                }
            }
            
            
            UIAlertView *alert =[[UIAlertView alloc] initWithTitle:@"授权恢复完毕"
                                                           message:@"授权恢复流程执行完毕"
                                                          delegate:nil
                                                 cancelButtonTitle:@"确定"
                                                 otherButtonTitles:nil];
            [alert show];
        }];
        
        
        
    }

}
- (NSString*) parseExpiresDate:(NSString*)data{
    NSLog(@"data %@",data);
    NSData *jsonData= [data dataUsingEncoding:NSASCIIStringEncoding];
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:nil];

    NSArray *rowsArr = dict[@"latest_receipt_info"];
    NSDictionary *dit = rowsArr[rowsArr.count-1];
    
    NSString* expires_date = dit[@"expires_date"];
    return expires_date;
}
/*
 func expirationDateFromResponse(jsonResponse: NSDictionary) → NSDate? {
 
 if let receiptInfo: NSArray = jsonResponse["latest_receipt_info"] as? NSArray {
 
 let lastReceipt = receiptInfo.lastObject as! NSDictionary
 var formatter = NSDateFormatter()
 formatter.dateFormat = "yyyy-MM-dd HH:mm:ss VV"
 
 let expirationDate: NSDate =
 formatter.dateFromString(lastReceipt["expires_date"] as! String) as NSDate!
 
 return expirationDate
 } else {
 return nil
 }
 }
 */
- (void)DoneClick
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
