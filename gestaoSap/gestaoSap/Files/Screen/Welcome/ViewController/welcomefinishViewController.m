//
//  welcomefinishViewController.m
//  gestaoSap
//
//  Created by User on 08/03/17.
//  Copyright © 2017 gntec. All rights reserved.
//

#import "welcomefinishViewController.h"
#import "loginViewController.h"

@interface welcomefinishViewController ()

@end

@implementation welcomefinishViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)logar:(UIButton *)sender
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    loginViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"loginViewController"];
    
    [self presentViewController:vc animated:YES completion:nil];
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
