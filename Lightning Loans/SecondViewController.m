//
//  SecondViewController.m
//  Lightning Loans
//
//  Created by sunmeng on 16/4/2.
//  Copyright © 2016年 Sun Meng. All rights reserved.
//

#import "SecondViewController.h"
#import <MJRefresh/MJRefresh.h>
#import "Utils.h"
#import <AVOSCloud/AVOSCloud.h>
#import "UIImageView+AFNetworking.h"

@interface SecondViewController ()

@property (nonatomic, copy) NSMutableArray *dataOfArticle;

@end

@implementation SecondViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    __weak typeof(self) weakSelf = self;
    //下拉刷新
    // 设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的loadNewData方法）
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    
    // 设置自动切换透明度(在导航栏下面自动隐藏)
    header.automaticallyChangeAlpha = YES;
    // 隐藏时间
    header.lastUpdatedTimeLabel.hidden = YES;
    // 马上进入刷新状态
    self.tableView.mj_header = header;
    
    //上拉刷新
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [weakSelf loadMoreData];
    }];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //每次进来自动调用下拉刷新
    [self.tableView.mj_header beginRefreshing];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.dataOfArticle count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SecondTableCell" forIndexPath:indexPath];
    
    UILabel *label = (UILabel *)[cell viewWithTag:1002];
    UIImageView *imageView = (UIImageView *)[cell viewWithTag:1001];
    AVObject *articleObject = self.dataOfArticle[indexPath.row];
    label.text = articleObject[@"title"];
    NSString *url=articleObject[@"thumbImage"];
    [imageView setImageWithURL:[NSURL URLWithString:url] placeholderImage:nil];   return cell;
}

#pragma mark - 刷新数据
- (void)loadNewData
{
    NSLog(@"fuck");
    //下拉刷新获得数据 最多返回10组新闻
    if ([self.dataOfArticle count] != 0)
    {
        [self.tableView.mj_header endRefreshing];
    }
    else
    {
        AVQuery *query = [AVQuery queryWithClassName:@"ArticleTable"];
        [query whereKey:@"priority" equalTo:@0];
        [query orderByAscending:@"createdAt"]; //按创建时间循序排列
        query.limit = 10; // 最多返回 10 条结果
        __weak typeof(self) weakSelf = self;
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            NSArray<AVObject *> *priorityEqualsZeroTodos = objects;// 符合 priority = 0 的 Todo 数组
            [weakSelf.dataOfArticle addObjectsFromArray:priorityEqualsZeroTodos];
            [weakSelf.tableView.mj_header endRefreshing];
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf.tableView reloadData];
            });
        }];
    }
}

- (void)loadMoreData
{
    //上拉刷新获得数据 最多返回10组新闻
    [self.tableView.mj_footer endRefreshing];

}

- (NSMutableArray *)dataOfArticle
{
    if (!_dataOfArticle)
    {
        _dataOfArticle = [[NSMutableArray alloc] initWithCapacity:10];
    }
    return _dataOfArticle;
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
}

@end
