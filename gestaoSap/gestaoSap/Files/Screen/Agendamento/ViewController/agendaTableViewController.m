//
//  agendaTableViewController.m
//  gestaoSap
//
//  Created by User on 17/01/17.
//  Copyright © 2017 gntec. All rights reserved.
//

#import "agendaTableViewController.h"
#import "VariaveisGlobais.h"

@interface agendaTableViewController ()
{
    
    NSInteger arryTable;

}

@property (assign, nonatomic) BOOL updating;
@property (strong, nonatomic) LLARingSpinnerView *spinnerView;

@end

@implementation agendaTableViewController
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

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //[self escondeCellProfissional];
    [self setupUI];
}

-(void) setupUI {
    
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:77/255.0 green:182/255.0 blue:172/255.0 alpha:1];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [self.navigationController.navigationBar
     setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    self.navigationController.navigationBar.translucent = NO;
    
    self.textUnidade.text = [VariaveisGlobais shared]._nomeFilial;
    self.textServico.text = [VariaveisGlobais shared]._servico;
    self.textProfissional.text = [VariaveisGlobais shared]._profissional;
    self.textHora.text = [VariaveisGlobais shared]._horarioAgendamento;
    
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"dd/MM/yyyy"];
    NSString *strDataAgendamento = [format stringFromDate:[VariaveisGlobais shared]._dataAgendamento];
    
    self.textData.text = strDataAgendamento;
}

-(void) updateUI
{
    
}
-(void) escondeCellProfissional
{
    if (self.segProfissional.selectedSegmentIndex == 1)
    {
        self.cellProfissional.hidden = true;
    }
}

- (IBAction)mostraCellProfissional:(id)sender {
 
    if (self.segProfissional.selectedSegmentIndex == 0)
    {
        self.cellProfissional.hidden = false;
        
    }
    else if (self.segProfissional.selectedSegmentIndex == 1)
    {
        self.cellProfissional.hidden = true;
    }
}

-(IBAction)onclickAgendar:(id)sender
{
    self.textUnidade.text = [VariaveisGlobais shared]._nomeFilial;
    self.textServico.text = [VariaveisGlobais shared]._servico;
    self.textProfissional.text = [VariaveisGlobais shared]._profissional;
    self.textHora.text = [VariaveisGlobais shared]._horarioAgendamento;
    
    
    //VERIFICA SE OS CAMPOS FORAM PREENCHIDOS
    if([self.textServico.text isEqualToString:@""])
    {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Erro" message:@"Por favor escolha uma Data !" preferredStyle:UIAlertControllerStyleAlert];
    
        UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:ok];
        
        [self presentViewController:alertController animated:YES completion:nil];
        
        return;
    }

    if (self.segProfissional.selectedSegmentIndex == 1)
    {
        if([self.textServico.text isEqualToString:@""])
        {
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Erro" message:@"Por favor escolha um Profissional !" preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
            [alertController addAction:ok];
            
            [self presentViewController:alertController animated:YES completion:nil];
            
            return;
        }
    }
    
    if([self.textData.text isEqualToString:@""])
    {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Erro" message:@"Por favor escolha uma Data !" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:ok];
        
        [self presentViewController:alertController animated:YES completion:nil];
        
        return;
    }
    
    if([self.textHora.text isEqualToString:@""])
    {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Erro" message:@"Por favor escolha um Horário !" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:ok];
        
        [self presentViewController:alertController animated:YES completion:nil];
        
        return;
    }
    
    //CHAMA A FUNÇÃO QUE GRAVA O AGENDAMENTO
    
    self.updating = true;
    [self agendar:^(NSDictionary *dict, NSError *error) {
        
        if (dict.count > 0) {
            
            NSString *codAgendamento = [dict objectForKey:@"COD_AGENDAMENTO"];
            if(codAgendamento != 0)
            {
                NSString *mensagemRetorno = [dict objectForKey:@"MSG_RETORNO"];
                
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Informação" message:mensagemRetorno preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
                [alertController addAction:ok];
                
                [self presentViewController:alertController animated:YES completion:nil];
                self.updating =false;
            }

//            dispatch_async(dispatch_get_main_queue(), ^{
//                [self.tableProfissional reloadData];
//                self.updating = false;
//            });
        }
        else
        {
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Erro" message:@"Erro ao regalizar o agendamento !" preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
            [alertController addAction:ok];
            
            [self presentViewController:alertController animated:YES completion:nil];
            self.updating =false;
            
        }
    }];
    
    
}

- (void)agendar:(void(^)(NSDictionary *dict, NSError *error))block
{
    if (block) {
        
//        <web:COD_EMPRESA>?</web:COD_EMPRESA>
//        <web:COD_FILIAL>?</web:COD_FILIAL>
//        <web:COD_AGENDAMENTO>?</web:COD_AGENDAMENTO>
//        <web:COD_CLIENTE>?</web:COD_CLIENTE>
//        <web:COD_SERVICO>?</web:COD_SERVICO>
//        <web:COD_PROFISSIONAL>?</web:COD_PROFISSIONAL>
//        <!--Optional:-->
//        <web:DATA>?</web:DATA>
//        <!--Optional:-->
//        <web:HORA>?</web:HORA>
        
        SOAPEngine *soap = [[SOAPEngine alloc]init];
        soap.actionNamespaceSlash = YES;
        soap.requestTimeout = 10;
        soap.licenseKey = @"3hJP454la9UT4vl+7+imMyYa+BywnzS+SIsGTHAoE2lmyDY0vExuMYV8594krLhAl9/F69zo3LJTB6Wr0ZRuHQ==";
        
        [soap setIntegerValue:[VariaveisGlobais shared]._codEmpresa forKey:@"COD_EMPRESA"];
        [soap setIntegerValue:[VariaveisGlobais shared]._codUnidade forKey:@"COD_FILIAL"];
        [soap setIntegerValue:0 forKey:@"COD_AGENDAMENTO"];
        [soap setIntegerValue:[VariaveisGlobais shared]._codCliente forKey:@"COD_CLIENTE"];
        [soap setIntegerValue:[VariaveisGlobais shared]._codServico forKey:@"COD_SERVICO"];
        [soap setIntegerValue:[VariaveisGlobais shared]._codProfissional forKey:@"COD_PROFISSIONAL"];
        [soap setValue:self.textData.text forKey:@"DATA"];
        [soap setValue:self.textHora.text forKey:@"HORA"];
    
        [soap requestURL:@"http://www.gestaospa.com.br/PROD/WebSrv/WebServiceGestao.asmx"
              soapAction:@"http://www.gestaospa.com.br/PROD/WebSrv/SET_AGENDAMENTO_2"
  completeWithDictionary:^(NSInteger statusCode, NSDictionary *dict) {
      
      block(dict, nil);
      
  } failWithError:^(NSError *error) {
      block(nil, error);
  }];
        
    }
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


@end
