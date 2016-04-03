//
//  FirstViewController.m
//  Lightning Loans
//
//  Created by 孙萌 on 16/4/2.
//  Copyright © 2016年 Sun Meng. All rights reserved.
//

#import "FirstViewController.h"
#import <AVOSCloud/AVOSCloud.h>
#import <MJRefresh/MJRefresh.h>

@interface FirstViewController ()<UIWebViewDelegate>

@property (nonatomic, copy) NSString *firstViewURL;

@end

@implementation FirstViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //添加下拉刷新控件
    UIScrollView *scrollView = self.fastLoanWebView.scrollView;
    __weak typeof(self) weakSelf = self;
    scrollView.mj_header= [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf.fastLoanWebView reload];
    }];
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

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [self.fastLoanWebView.scrollView.mj_header endRefreshing];
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
    AVQuery *query = [AVQuery queryWithClassName:@"FirstViewURL"];
    [query whereKey:@"priority" equalTo:@0];
#warning 更新自己
    [query getFirstObjectInBackgroundWithBlock:^(AVObject *object, NSError *error) {
        // object 就是符合条件的第一个 AVObject
        if (object)
        {
            NSString *urlString = object[@"url"];
            NSLog(@"从服务器端获取到的firstView URl: %@", urlString);
            //检测是否能打开此链接，验证连接的合法性
            BOOL canOpenGivenURL = [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:urlString]];
            if (canOpenGivenURL)
            {
                if (![weakSelf.firstViewURL isEqualToString:urlString])
                {
                    NSLog(@"远程服务器更新url");
                    weakSelf.firstViewURL = urlString;
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [weakSelf startWeb];
                    });
                }
                else if (isRefresh)
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
