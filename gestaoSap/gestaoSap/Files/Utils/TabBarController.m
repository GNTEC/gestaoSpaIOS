//
//  TabBarViewController.m
//  gestaoSap
//
//  Created by User on 07/02/17.
//  Copyright © 2017 gntec. All rights reserved.
//

#import "TabBarController.h"
#import "VariaveisGlobais.h"

@implementation TabBarController
-(void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item {
    if (item == tabBar.items[0]) {
        
    } else {
        [VariaveisGlobais shared]._nomeFilial = @"";
        [VariaveisGlobais shared]._servico = @"";
        [VariaveisGlobais shared]._profissional = @"";
        [VariaveisGlobais shared]._horarioAgendamento = @"";
        [VariaveisGlobais shared]._dataAgendamento = nil;
        
        
    }
}

@end
