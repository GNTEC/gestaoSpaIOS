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
