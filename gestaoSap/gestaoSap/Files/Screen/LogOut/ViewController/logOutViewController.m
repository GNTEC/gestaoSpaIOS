//
//  logOutViewController.m
//  gestaoSap
//
//  Created by User on 19/01/17.
//  Copyright © 2017 gntec. All rights reserved.
//

#import "logOutViewController.h"

@interface logOutViewController ()

@end

@implementation logOutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"loginViewController"];
    [self presentViewController:vc animated:YES completion:nil];
    
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
