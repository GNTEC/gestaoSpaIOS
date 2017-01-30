//
//  historicoAgendamentoTableViewController.m
//  gestaoSap
//
//  Created by User on 27/01/17.
//  Copyright © 2017 gntec. All rights reserved.
//

#import "historicoAgendamentoTableViewController.h"
#import "JSONKit.h"

@interface historicoAgendamentoTableViewController ()
{

}
@property (strong, nonatomic) NSMutableArray *arrayDataHistoricoServico;

@end

@implementation historicoAgendamentoTableViewController
-(NSMutableArray *)arrayDataHistoricoServico {
    if (!_arrayDataHistoricoServico) {
        _arrayDataHistoricoServico = [[NSMutableArray alloc] init];
    }
    return _arrayDataHistoricoServico;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
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
    
    [self  historicoAgendamentos];
    
    if(spinnerView.isAnimating)
    {
        [spinnerView stopAnimating];
        [spinnerView removeFromSuperview];
    }
}


-(void)historicoAgendamentos
{
    //CHAMA A FUNÇÃO QUE FAZ O LOGIN
    [self getHistoricoAgendamentos:^(NSDictionary *dict, NSError *error) {
        
        if (dict.count > 0) {
            
            NSMutableDictionary *arrayAgendamento = [[NSMutableDictionary alloc] init];
            arrayAgendamento = [dict objectForKey:@"Agendamento"];
            

            NSDictionary *topLevelJSON = [NSJSONSerialization JSONObjectWithData:dict options:0 error:nil];
            NSString *lowLevelString = [[topLevelJSON firstObject] objectForKey:@"data"];
            NSData *lowLevelData = [lowLevelString dataUsingEncoding:NSUTF8StringEncoding];
            NSDictionary *final = [NSJSONSerialization JSONObjectWithData:lowLevelData options:0 error:nil];
            
            
            
            NSMutableDictionary *arrayCliente = [[NSMutableDictionary alloc] init];
            arrayCliente = [arrayAgendamento objectForKey:@"CLIENTE"];
            
 //           NSMutableArray *arrayProfissinal = [[NSMutableArray alloc] init];
 //           arrayProfissinal = [arrayAgendamento objectAtIndex:2];
            
 //           NSMutableArray *arrayServico = [[NSMutableArray alloc] init];
 //           arrayServico = [arrayAgendamento objectAtIndex:5];
            
            for(int i = 0; i < [arrayAgendamento count]; ++i)
            {
                historicoAgendamento *objHistoricoAgendamento = [[historicoAgendamento alloc]init];
                
                //[{"COD_AGENDAMENTO":2388061,"PROFISSIONAL":{"COD_PROFISSIONAL":16,"NOME":"Marli"},"SERVICO":{"COD_SERVICO":5677,"DSC_SERVICO":"aplicação de enzima","VALOR":80},"CLIENTE":{"COD_CLIENTE":1055,"NOME":"Claudio Matteucci","MSG_RETORNO":""},"DATA":"27/01/2017","HORA":"08:00","STATUS":"PENDENTE"}
                
 //               objHistoricoAgendamento.codAgendamento = [[[arrayAgendamento objectAtIndex:i]objectForKey:@"COD_AGENDAMENTO"] integerValue];
                
//                objHistoricoAgendamento.codProfissional = [[[arrayProfissinal objectAtIndex:i]objectForKey:@"COD_PROFISSIONAL"] integerValue];
//                objHistoricoAgendamento.nomeProfissional = [[arrayProfissinal objectAtIndex:i]objectForKey:@"NOME"];
                
//                objHistoricoAgendamento.descricaoServico = [[arrayServico objectAtIndex:i]objectForKey:@"DSC_SERVICO"];
//                objHistoricoAgendamento.valor = [[arrayServico objectAtIndex:i]objectForKey:@"VALOR"];
                
 //               objHistoricoAgendamento.nomeCliente = [[arrayCliente objectAtIndex:i]objectForKey:@"NOME"];
                //objHistoricoAgendamento.msgRetorno = [[arrayDataServico1 objectAtIndex:i]objectForKey:@"MSG_RETORNO"];
                
 //               objHistoricoAgendamento.dataAgendametoServico = [[arrayAgendamento objectAtIndex:i]objectForKey:@"DATA"];
 //               objHistoricoAgendamento.horaAgendamentoServico = [[arrayAgendamento objectAtIndex:i]objectForKey:@"HORA"];
 //               objHistoricoAgendamento.statusServico = [[arrayAgendamento objectAtIndex:i]objectForKey:@"STATUS"];
                
                [self.arrayDataHistoricoServico  addObject:objHistoricoAgendamento];
                
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                //[self.tableServico reloadData];
            });
        }
        else
        {
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Erro" message:@"Não existe Serviços realozados !" preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
            [alertController addAction:ok];
            
            [self presentViewController:alertController animated:YES completion:nil];
            
        }
    }];
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
    return 7;
}

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

- (void)getHistoricoAgendamentos:(void(^)(NSDictionary *dict, NSError *error))block
{
    if (block) {
        SOAPEngine *soap = [[SOAPEngine alloc]init];
        soap.actionNamespaceSlash = YES;
        soap.requestTimeout = 10;
        soap.licenseKey = @"3hJP454la9UT4vl+7+imMyYa+BywnzS+SIsGTHAoE2lmyDY0vExuMYV8594krLhAl9/F69zo3LJTB6Wr0ZRuHQ==";
        
        [soap setIntegerValue:[VariaveisGlobais shared]._codEmpresa forKey:@"COD_EMPRESA"];
        [soap setIntegerValue:[VariaveisGlobais shared]._codUnidade forKey:@"COD_FILIAL"];
        [soap setIntegerValue:[VariaveisGlobais shared]._codCliente forKey:@"COD_CLIENTE"];
        [soap requestURL:@"http://www.gestaospa.com.br/PROD/WebSrv/WebServiceGestao.asmx"
              soapAction:@"http://www.gestaospa.com.br/PROD/WebSrv/GET_AGENDAMENTOS"
  completeWithDictionary:^(NSInteger statusCode, NSData *dict) {
      
      block(dict, nil);
      
  } failWithError:^(NSError *error) {
      block(nil, error);
  }];
        
    }
}


@end
