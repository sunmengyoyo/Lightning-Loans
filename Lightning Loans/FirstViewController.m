//
//  FirstViewController.m
//  Lightning Loans
//
//  Created by 孙萌 on 16/4/2.
//  Copyright © 2016年 Sun Meng. All rights reserved.
//

#import "FirstViewController.h"
#import <AVOSCloud/AVOSCloud.h>

@interface FirstViewController ()

@property (nonatomic, copy) NSString *firstViewURL;

@end

@implementation FirstViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //app delegate 在launch finish也调用getFirstViewURL 防止两次调用
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"isLaunch"])
    {
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"isLaunch"];
        NSLog(@"set no");
    }
    else
    {
        NSLog(@"start");
        [self getFirstViewURL:NO];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//refresh bar item
- (IBAction)refresh:(id)sender {
    [self getFirstViewURL:YES];
}


//初始化url
- (void)startWeb
{
    NSLog(@"startWeb 开始配置首页,%@",self.firstViewURL);
    NSURL *url = [NSURL URLWithString:self.firstViewURL];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
    [self.fastLoanWebView loadRequest:urlRequest];
}

//返回是否连接改变
- (void)getFirstViewURL:(BOOL)isRefresh
{
    __weak typeof(self) weakSelf = self;
    AVQuery *query = [AVQuery queryWithClassName:@"TestObject"];
#warning 更新自己的id卡；
    [query  getObjectInBackgroundWithId:@"#" block:^(AVObject *object, NSError *error) {
        if (object)
        {
            NSLog(@"从服务器端获取到的firstView URl: %@", object[@"words"]);
            //检测是否能打开此链接，验证连接的合法性
            BOOL canOpenGivenURL = [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:object[@"words"]]];
            if (canOpenGivenURL)
            {
                if (![weakSelf.firstViewURL isEqualToString:object[@"words"]] && object[@"words"])
                {
                    NSLog(@"远程服务器更新url");
                    weakSelf.firstViewURL = [object objectForKey:@"words"];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [weakSelf startWeb];
                    });
                }
                else if (isRefresh && object[@"words"])
                {
                    //刷新到主页
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [weakSelf startWeb];
                    });
                }
            }
            else
            {
                NSLog(@"失败了, %@", error);
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"好像出错了" message:@"闪电贷服务器正在更新，请稍后重试" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
                [alertView show];
                [AVAnalytics event:@"firstURL 返回值为错误的url"];
            }
        }
        else
        {
            NSLog(@"失败了, %@", error);
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"好像出错了" message:@"闪电贷提供的服务需要连接网络" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
            [alertView show];
        }
    }];
}

@end
