//
//  maisTableViewController.m
//  gestaoSap
//
//  Created by User on 27/02/17.
//  Copyright © 2017 gntec. All rights reserved.
//

#import "maisTableViewController.h"
#import "VariaveisGlobais.h"

@interface maisTableViewController ()

@end

@implementation maisTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
}

-(void) setupUI {
    
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:77/255.0 green:182/255.0 blue:172/255.0 alpha:1];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [self.navigationController.navigationBar
     setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    self.navigationController.navigationBar.translucent = NO;
}

-(void) updateUI
{
    
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
    return 2;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.row == 0) {
        
        UIViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"unidadeViewController"];
        [self presentViewController:vc animated:YES completion:nil];
    }
    else
    {
        [VariaveisGlobais shared]._codAgendamento = 0;
        [VariaveisGlobais shared]._codCliente = 0;
        [VariaveisGlobais shared]._codEmpresa = 0;
        [VariaveisGlobais shared]._codUnidade = 0;
        [VariaveisGlobais shared]._nomeFilial = @"";
        [VariaveisGlobais shared]._enderecoFilial = @"";
        [VariaveisGlobais shared]._codServico = 0;
        [VariaveisGlobais shared]._servico = @"";
        [VariaveisGlobais shared]._dataAgendamento = 0;
        [VariaveisGlobais shared]._codProfissional = 0;
        [VariaveisGlobais shared]._profissional = @"";
        [VariaveisGlobais shared]._horarioAgendamento = @"";
        [VariaveisGlobais shared]._codAgendamento = 0;
        
        UIViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"loginViewController"];
        [self presentViewController:vc animated:YES completion:nil];
    }
}


@end
