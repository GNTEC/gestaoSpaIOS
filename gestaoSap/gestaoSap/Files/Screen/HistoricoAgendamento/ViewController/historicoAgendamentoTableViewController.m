//
//  historicoAgendamentoTableViewController.m
//  gestaoSap
//
//  Created by User on 27/01/17.
//  Copyright © 2017 gntec. All rights reserved.
//

#import "historicoAgendamentoTableViewController.h"
#import "HistoricoTableViewCell.h"
#import "HistoricoAgendamentoDetalheViewController.h"

@interface historicoAgendamentoTableViewController ()
{

}

@property (assign, nonatomic) BOOL updating;
@property (strong, nonatomic) LLARingSpinnerView *spinnerView;
@property (strong, nonatomic) NSMutableArray *arrayDataHistoricoServico;
@property (strong, nonatomic) historicoAgendamento *stListaHistoricoAgendamento;

@end

@implementation historicoAgendamentoTableViewController

-(IBAction)backToHistory:(UIStoryboardSegue *)sender {
 
    
}
-(LLARingSpinnerView *)spinnerView {
    if (!_spinnerView) {
        _spinnerView = [[LLARingSpinnerView alloc] initWithFrame:CGRectMake(0, 0, 250, 250)];
        _spinnerView.tintColor = [UIColor blackColor];
        // Optionally set the current progress
        _spinnerView.lineWidth = 1.5f;
        _spinnerView.hidesWhenStopped = YES;
    }
    return _spinnerView;
}

-(void)setUpdating:(BOOL)updating {
    _updating = updating;
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.updating) {
            [self.spinnerView startAnimating];
        } else {
            [self.spinnerView stopAnimating];
        }
    });
}

-(NSMutableArray *)arrayDataHistoricoServico {
    if (!_arrayDataHistoricoServico) {
        _arrayDataHistoricoServico = [[NSMutableArray alloc] init];
    }
    return _arrayDataHistoricoServico;
}

-(void) setupUI {
    
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:77/255.0 green:182/255.0 blue:172/255.0 alpha:1];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [self.navigationController.navigationBar
     setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    self.navigationController.navigationBar.translucent = NO;
    
    self.spinnerView.center = CGPointMake(CGRectGetMidX(self.view.bounds), CGRectGetMidY(self.view.bounds));
    //spinnerView.backgroundColor = [UIColor grayColor];
    // Add it as a subview
    [self.view addSubview:self.spinnerView];
    
}

-(void) updateUI
{
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];
    [self historicoAgendamentos];
}

- (void) viewWillAppear:(BOOL)animated
{
    
}

-(void)viewDidAppear:(BOOL)animated {
    [self setupUI];
    [self historicoAgendamentos];
}

-(void)historicoAgendamentos
{
    self.updating = YES;
    
    //CHAMA A FUNÇÃO QUE FAZ O LOGIN
    [self getHistoricoAgendamentos:^(NSDictionary *dict, NSError *error) {
        
        NSMutableArray *arrayDataHistoricoServico1 = [[NSMutableArray alloc] init];
        
        if (dict.count > 0)
        {
            
            NSArray *dataArray = [dict objectForKey:@"Agendamento"];
      
            for(int i = 0; i < [dataArray count]; ++i)
            {
               historicoAgendamento *objHistoricoAgendamento = [[historicoAgendamento alloc]init];
                
                NSDictionary *dataArrayProfissional = [dataArray objectAtIndex:i];
                NSArray *profissional = [dataArrayProfissional objectForKey:@"PROFISSIONAL"];
                
                NSDictionary *dataArrayServico = [dataArray objectAtIndex:i];
                NSArray *servico = [dataArrayServico objectForKey:@"SERVICO"];
                
                NSDictionary *dataArrayClientes = [dataArray objectAtIndex:i];
                NSArray *cliente = [dataArrayClientes objectForKey:@"CLIENTE"];
                
                objHistoricoAgendamento.codAgendamento = [[[dataArray objectAtIndex:i]objectForKey:@"COD_AGENDAMENTO"] integerValue];
                objHistoricoAgendamento.codProfissional = [[profissional valueForKey:@"COD_PROFISSIONAL"] integerValue];
                objHistoricoAgendamento.nomeProfissional = [profissional valueForKey:@"NOME"];
                
                objHistoricoAgendamento.descricaoServico = [servico valueForKey:@"DSC_SERVICO"];
                objHistoricoAgendamento.valor = [servico valueForKey:@"VALOR"];
                
                objHistoricoAgendamento.nomeCliente = [cliente valueForKey:@"NOME"];
                objHistoricoAgendamento.msgRetorno = [cliente valueForKey:@"MSG_RETORNO"];
                
                objHistoricoAgendamento.dataAgendametoServico = [[dataArray objectAtIndex:i]objectForKey:@"DATA"];
                objHistoricoAgendamento.horaAgendamentoServico = [[dataArray objectAtIndex:i]objectForKey:@"HORA"];
                objHistoricoAgendamento.statusServico = [[dataArray objectAtIndex:i]objectForKey:@"STATUS"];
                
                [arrayDataHistoricoServico1  addObject:objHistoricoAgendamento];
                
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                self.arrayDataHistoricoServico = arrayDataHistoricoServico1;
                [self.tableHistorico reloadData];
                self.updating = NO;
            });
        }
        else
        {
            
            self.updating = NO;
            
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Erro" message:@"Não Existe Histórico de Serviços" preferredStyle:UIAlertControllerStyleAlert];
            
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
    return [self.arrayDataHistoricoServico count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    HistoricoTableViewCell *celula = [tableView dequeueReusableCellWithIdentifier:@"cellHistorico"];
    
    if(self.arrayDataHistoricoServico.count > 0)
    {
        //colocar texto nas celulas
        historicoAgendamento *stHistoricoAgendamento = [self.arrayDataHistoricoServico objectAtIndex:indexPath.row];
        
        celula.labelServico.text = stHistoricoAgendamento.descricaoServico;
        celula.labelProfissional.text = stHistoricoAgendamento.nomeProfissional;
        celula.labelData.text = stHistoricoAgendamento.dataAgendametoServico;
        celula.labelHora.text = stHistoricoAgendamento.horaAgendamentoServico;
        celula.labelStatus.text = stHistoricoAgendamento.statusServico;

    }

    return celula;
    
}

- (void)getHistoricoAgendamentos:(void(^)(NSDictionary *dict, NSError *error))block
{
    if (block) {
        SOAPEngine *soap = [[SOAPEngine alloc]init];
        soap.actionNamespaceSlash = YES;
        soap.requestTimeout = 10;
        soap.licenseKey = @"whRGNkHH719j5474Q0yqdui4sXxBFFxlGXsyjt6510NzrXIUx2TYRaDdNeWb2j0W/l6cD/xiB2NHyq8tzUjyXQ==";
        
        [soap setIntegerValue:[VariaveisGlobais shared]._codEmpresa forKey:@"COD_EMPRESA"];
        [soap setIntegerValue:[VariaveisGlobais shared]._codUnidade forKey:@"COD_FILIAL"];
        [soap setIntegerValue:[VariaveisGlobais shared]._codCliente forKey:@"COD_CLIENTE"];
        [soap requestURL:@"http://www.gestaospa.com.br/PROD/WebSrv/WebServiceGestao.asmx"
              soapAction:@"http://www.gestaospa.com.br/PROD/WebSrv/GET_AGENDAMENTOS"
  completeWithDictionary:^(NSInteger statusCode, NSDictionary *dict) {
      
      block(dict, nil);
      
  } failWithError:^(NSError *error) {
      block(nil, error);
  }];
        
    }
}

 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    historicoAgendamento *stHistoricoAgendamento = [self.arrayDataHistoricoServico objectAtIndex:[self.tableHistorico indexPathForSelectedRow].row];
    
    if ([segue.destinationViewController isKindOfClass:[HistoricoAgendamentoDetalheViewController class]])
    {
        HistoricoAgendamentoDetalheViewController *vc = segue.destinationViewController;
        vc.stHistoricoAgendamento = stHistoricoAgendamento;
    }
}

@end
