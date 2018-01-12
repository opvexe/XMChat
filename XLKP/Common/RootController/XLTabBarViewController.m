//
//  XLTabBarViewController.m
//  XLIM
//
//  Created by Facebook on 2017/11/20.
//  Copyright © 2017年 Facebook. All rights reserved.
//

#import "XLTabBarViewController.h"
#import "XLConversationListViewController.h"

@interface XLTabBarViewController ()

@end

@implementation XLTabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    XLConversationListViewController *conversation = [[XLConversationListViewController alloc]init];
    UINavigationController *navigationController = [[UINavigationController alloc]initWithRootViewController:conversation];
    navigationController.tabBarItem = [[UITabBarItem alloc]initWithTitle:@"聊天会话" image:nil selectedImage:nil];
    [self setViewControllers:@[navigationController]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
