//
//  dataAgendamentoViewController.m
//  gestaoSap
//
//  Created by User on 18/01/17.
//  Copyright © 2017 gntec. All rights reserved.
//

#import "dataAgendamentoViewController.h"

@interface dataAgendamentoViewController ()

@end

@implementation dataAgendamentoViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    _calendarManager = [JTCalendarManager new];
    _calendarManager.delegate = self;
    
    [_calendarManager setMenuView:_calendarMenuView];
    [_calendarManager setContentView:_calendarContentView];
    [_calendarManager setDate:[NSDate date]];
    
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
