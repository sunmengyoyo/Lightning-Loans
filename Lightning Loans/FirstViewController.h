//
//  FirstViewController.h
//  Lightning Loans
//
//  Created by 孙萌 on 16/4/2.
//  Copyright © 2016年 Sun Meng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FirstViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIWebView *fastLoanWebView;

- (void)getFirstViewURL:(BOOL)isRefresh;


@end

