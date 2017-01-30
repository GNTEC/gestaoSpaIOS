//
//  HorarioTableViewController.m
//  gestaoSap
//
//  Created by User on 19/01/17.
//  Copyright © 2017 gntec. All rights reserved.
//

#import "HorarioTableViewController.h"

@interface HorarioTableViewController ()
{
}
@property (strong, nonatomic) NSMutableArray *arrayDataHorario;
@end

@implementation HorarioTableViewController
-(NSMutableArray *)arrayDataHorario {
    if (!_arrayDataHorario) {
        _arrayDataHorario = [[NSMutableArray alloc] init];
    }
    return _arrayDataHorario;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void) viewWillAppear:(BOOL)animated
{
    
    LLARingSpinnerView *spinnerView = [[LLARingSpinnerView alloc] initWithFrame:CGRectMake(0, 0, 250, 250)];
    spinnerView.tintColor = [UIColor blackColor];
    spinnerView.center = CGPointMake(CGRectGetMidX(self.view.bounds), CGRectGetMidY(self.view.bounds));
    //spinnerView.backgroundColor = [UIColor grayColor];
    
    // Optionally set the current progress
    spinnerView.lineWidth = 1.5f;
    
    // Add it as a subview
    [self.view addSubview:spinnerView];
    
    // Spin it
    [spinnerView startAnimating];
    
    [self  horarios];
    
    if(spinnerView.isAnimating)
    {
        [spinnerView stopAnimating];
        [spinnerView removeFromSuperview];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)horarios
{
    //CHAMA A FUNÇÃO QUE FAZ O LOGIN
    [self getHorarios:^(NSDictionary *dict, NSError *error) {
        
        if (dict.count > 0) {
            
            NSMutableArray *arrayDataServico1 = [[NSMutableArray alloc] init];
            arrayDataServico1 = [dict objectForKey:@"array"];
            
            
            for(int i = 0; i < [arrayDataServico1 count]; ++i)
            {
                horario *objHorario = [[horario alloc]init];
                
                objHorario.codProfissional = [[[arrayDataServico1 objectAtIndex:i]objectForKey:@"COD_PROFISSIONAL"] integerValue];
                objHorario.dataIni = [[arrayDataServico1 objectAtIndex:i]objectForKey:@"DT_INI"];
                objHorario.dataFim = [[arrayDataServico1 objectAtIndex:i]objectForKey:@"DT_FIM"];
                
                [self.arrayDataHorario  addObject:objHorario];
                
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableHorario reloadData];
            });
        }
        else
        {
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Erro" message:@"Não existe Horarios disponiveis !" preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
            [alertController addAction:ok];
            
            [self presentViewController:alertController animated:YES completion:nil];
            
        }
    }];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.arrayDataHorario count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    horario *stHorario = [self.arrayDataHorario objectAtIndex:indexPath.row];
    
    cell.textLabel.text = stHorario.dataIni;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    horario *stHorario = [self.arrayDataHorario objectAtIndex:indexPath.row];
    [VariaveisGlobais shared]._horarioAgendamento = stHorario.dataIni;
    
    UITabBarController *tbc = [self.storyboard instantiateViewControllerWithIdentifier:@"MainTabBar"];
    tbc.selectedIndex=0;
    [self presentViewController:tbc animated:YES completion:nil];
}

- (void)getHorarios:(void(^)(NSDictionary *dict, NSError *error))block
{
    if (block) {
        
        NSDateFormatter *format = [[NSDateFormatter alloc] init];
        [format setDateFormat:@"dd/MM/yyyy"];
        NSString *strData = [format stringFromDate:[VariaveisGlobais shared]._dataAgendamento];
    
        SOAPEngine *soap = [[SOAPEngine alloc]init];
        soap.actionNamespaceSlash = YES;
        soap.requestTimeout = 10;
        soap.licenseKey = @"3hJP454la9UT4vl+7+imMyYa+BywnzS+SIsGTHAoE2lmyDY0vExuMYV8594krLhAl9/F69zo3LJTB6Wr0ZRuHQ==";
        
        [soap setIntegerValue:[VariaveisGlobais shared]._codEmpresa forKey:@"COD_EMPRESA"];
        [soap setIntegerValue:[VariaveisGlobais shared]._codUnidade forKey:@"COD_FILIAL"];
        [soap setValue:strData forKey:@"DATA_AGENDA"];
        [soap setIntegerValue:[VariaveisGlobais shared]._codProfissional forKey:@"COD_PROFISSIONAL"];
        [soap requestURL:@"http://www.gestaospa.com.br/PROD/WebSrv/WebServiceGestao.asmx"
              soapAction:@"http://www.gestaospa.com.br/PROD/WebSrv/GET_HORARIO_LIVRE_PROFISSIONAL_2"
  completeWithDictionary:^(NSInteger statusCode, NSDictionary *dict) {
      
      block(dict, nil);
      
      } failWithError:^(NSError *error) {
          block(nil, error);
      }];
            
    }
}

@end
