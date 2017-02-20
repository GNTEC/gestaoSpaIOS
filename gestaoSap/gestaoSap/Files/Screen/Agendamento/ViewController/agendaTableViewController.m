//
//  agendaTableViewController.m
//  gestaoSap
//
//  Created by User on 17/01/17.
//  Copyright © 2017 gntec. All rights reserved.
//

#import "agendaTableViewController.h"

@interface agendaTableViewController ()
{
    NSInteger arryTable;
}

@property (assign, nonatomic) BOOL updating;
@property (strong, nonatomic) LLARingSpinnerView *spinnerView;
@property (assign, nonatomic) BOOL showProfessional;

@end

@implementation agendaTableViewController
-(IBAction)backToSchedule:(UIStoryboardSegue *)sender {
    
    if([VariaveisGlobais shared]._codAgendamento != 0 && [VariaveisGlobais shared]._statusAgendamento == 2)
    {
        [self getAgendamento];
    }
    else
    {
        [self updateUI];
    }
}

-(void)viewDidAppear:(BOOL)animated {
    [self updateUI];
}

- (void)setShowProfessional:(BOOL)showProfessional
{
    _showProfessional = showProfessional;
    [self updateUI];
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

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];
    [self updateUI];
}

-(void) setupUI {
    
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:77/255.0 green:182/255.0 blue:172/255.0 alpha:1];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [self.navigationController.navigationBar
     setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    self.navigationController.navigationBar.translucent = NO;
    
    self.showProfessional = YES;
    
    self.spinnerView.center = CGPointMake(CGRectGetMidX(self.view.bounds), CGRectGetMidY(self.view.bounds));
    
    //self.spinnerView.center = self.view.center;
    [self.view addSubview:self.spinnerView];
}

-(void)limparTela
{
    [VariaveisGlobais shared]._profissional = nil;
    [VariaveisGlobais shared]._horarioAgendamento = nil;
    [VariaveisGlobais shared]._dataAgendamento = nil;
}

-(void)limparHorarioAgendamento
{
    [VariaveisGlobais shared]._horarioAgendamento = nil;
}

-(void) updateUI
{
    //self.textUnidade.text = [VariaveisGlobais shared]._nomeFilial;
    if([VariaveisGlobais shared]._servico != nil)
    {
        self.textServico.text = [VariaveisGlobais shared]._servico;
    }
    
    if([VariaveisGlobais shared]._profissional != nil)
    {
        self.textProfissional.text = [VariaveisGlobais shared]._profissional;
    }
    
    if([VariaveisGlobais shared]._horarioAgendamento != nil)
    {
        self.textHora.text = [VariaveisGlobais shared]._horarioAgendamento;
    }

    if([VariaveisGlobais shared]._dataAgendamento != nil)
    {
        NSDateFormatter *format = [[NSDateFormatter alloc] init];
        [format setDateFormat:@"dd/MM/yyyy"];
        NSString *strDataAgendamento = [format stringFromDate:[VariaveisGlobais shared]._dataAgendamento];
        self.textData.text = strDataAgendamento;
    }
    else
    {
        self.textData.text = [VariaveisGlobais shared]._dataAgendamento1;
    }
    
    [self.tableView reloadData];
}

-(IBAction)onclickAgendar:(id)sender
{    
    //VERIFICA SE OS CAMPOS FORAM PREENCHIDOS
    if([VariaveisGlobais shared]._servico == nil)
    {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Erro" message:@"Por favor escolha um Serviço !" preferredStyle:UIAlertControllerStyleAlert];
    
        UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:ok];
        
        [self presentViewController:alertController animated:YES completion:nil];
        
        return;
    }
    
    if([VariaveisGlobais shared]._dataAgendamento == nil)
    {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Erro" message:@"Por favor escolha uma Data !" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:ok];
        
        [self presentViewController:alertController animated:YES completion:nil];
        
        return;
    }
    
    if ([VariaveisGlobais shared]._withProfissional == 1)
    {
        if([VariaveisGlobais shared]._profissional == nil)
        {
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Erro" message:@"Por favor escolha um Profissional !" preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
            [alertController addAction:ok];
            
            [self presentViewController:alertController animated:YES completion:nil];
            
            return;
        }
    }
    
    if([VariaveisGlobais shared]._horarioAgendamento == nil)
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
        
        NSString *strMensagemRetorno;
        
        if (dict.count > 0) {
            
            NSInteger codAgendamento = [[dict objectForKey:@"COD_AGENDAMENTO"] integerValue];
            strMensagemRetorno = [dict objectForKey:@"MSG_RETORNO"];

            if(codAgendamento != 0)
            {
                [VariaveisGlobais shared]._codAgendamento = 0;
                [VariaveisGlobais shared]._codAgendamento = codAgendamento;
                [VariaveisGlobais shared]._statusAgendamento = 0;
                
                [self performSegueWithIdentifier:@"Schedule" sender:self];
            }
            self.updating = false;
        }
        else
        {
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Erro" message:strMensagemRetorno preferredStyle:UIAlertControllerStyleAlert];
            
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
        
        NSString *strDataAgendamento;
        
        if([VariaveisGlobais shared]._dataAgendamento != nil)
        {
            NSDateFormatter *format = [[NSDateFormatter alloc] init];
            [format setDateFormat:@"dd/MM/yyyy"];
            strDataAgendamento = [format stringFromDate:[VariaveisGlobais shared]._dataAgendamento];
        }
        else
        {
            strDataAgendamento = [VariaveisGlobais shared]._dataAgendamento1;
        }
        
        //HORA
        NSString *dateStr = [VariaveisGlobais shared]._horarioAgendamento;
        NSDateFormatter *dateFormatter=[NSDateFormatter new];
        [dateFormatter setDateFormat:@"dd/MM/yyyy hh:mm:ss"];
        NSDate *date=[dateFormatter dateFromString:dateStr];
        
        NSDateFormatter *dfTime = [NSDateFormatter new];
        [dfTime setDateFormat:@"hh:mm:ss"];
        NSString *strHora=[dfTime stringFromDate:date];
        
        SOAPEngine *soap = [[SOAPEngine alloc]init];
        soap.actionNamespaceSlash = YES;
        soap.requestTimeout = 10;
        soap.licenseKey = @"3hJP454la9UT4vl+7+imMyYa+BywnzS+SIsGTHAoE2lmyDY0vExuMYV8594krLhAl9/F69zo3LJTB6Wr0ZRuHQ==";
        
        //VERIFICA SE O AGENDAMENTO VAI SER ALTERADO
        NSInteger codAgendamento= 0;
        
        if ([VariaveisGlobais shared]._codAgendamento != 0)
        {
            codAgendamento = [VariaveisGlobais shared]._codAgendamento;
        }

        [soap setIntegerValue:[VariaveisGlobais shared]._codEmpresa forKey:@"COD_EMPRESA"];
        [soap setIntegerValue:[VariaveisGlobais shared]._codUnidade forKey:@"COD_FILIAL"];
        [soap setIntegerValue:codAgendamento forKey:@"COD_AGENDAMENTO"];
        [soap setIntegerValue:[VariaveisGlobais shared]._codCliente forKey:@"COD_CLIENTE"];
        [soap setIntegerValue:[VariaveisGlobais shared]._codServico forKey:@"COD_SERVICO"];
        [soap setIntegerValue:[VariaveisGlobais shared]._codProfissional forKey:@"COD_PROFISSIONAL"];
        [soap setValue:strDataAgendamento forKey:@"DATA"];
        [soap setValue:strHora forKey:@"HORA"];
    
        [soap requestURL:@"http://www.gestaospa.com.br/PROD/WebSrv/WebServiceGestao.asmx"
              soapAction:@"http://www.gestaospa.com.br/PROD/WebSrv/SET_AGENDAMENTO_2"
  completeWithDictionary:^(NSInteger statusCode, NSDictionary *dict) {
      
      block(dict, nil);
      
      } failWithError:^(NSError *error) {
          block(nil, error);
      }];
    }
}

-(void)getAgendamento
{
    self.updating = true;
    
    NSNumberFormatter *n = [[NSNumberFormatter alloc] init];
    [n setNumberStyle:NSNumberFormatterCurrencyStyle];
    NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"pt_BR"];
    [n setLocale:locale];
    
    //CHAMA A FUNÇÃO QUE FAZ O LOGIN
    [self getAgendamentos:^(NSDictionary *dict, NSError *error) {
        
        if (dict.count > 0)
        {
            NSArray *profissional = [dict allValues][2];
            NSArray *servico = [dict allValues][5];
            
            [VariaveisGlobais shared]._codServico = [[servico valueForKey:@"COD_SERVICO"] integerValue];
            [VariaveisGlobais shared]._servico = [servico valueForKey:@"DSC_SERVICO"];
            self.textServico.text = [VariaveisGlobais shared]._servico;
            
            [VariaveisGlobais shared]._dataAgendamento1 = [dict allValues][1];
            self.textData.text = [dict allValues][1];

            [VariaveisGlobais shared]._codProfissional = [[profissional valueForKey:@"COD_PROFISSIONAL"] integerValue];
            [VariaveisGlobais shared]._profissional = [profissional valueForKey:@"NOME"];
            self.textProfissional.text = [profissional valueForKey:@"NOME"];
            
            [VariaveisGlobais shared]._horarioAgendamento = [dict allValues][4];
            self.textHora.text = [dict allValues][4];
            
            [self updateUI];
            
            self.updating = NO;
        }
        else
        {
            self.updating = NO;
            
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"ERRO" message:@"Agendamento não encontrado !" preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                       handler:^(UIAlertAction * _Nonnull action) {
                                                           [self performSegueWithIdentifier:@"back" sender:self];
                                                       }];
            
            [alertController addAction:ok];
            self.updating = NO;
        }
    }];
}

- (void)getAgendamentos:(void(^)(NSDictionary *dict, NSError *error))block
{
    if (block) {
        SOAPEngine *soap = [[SOAPEngine alloc]init];
        soap.actionNamespaceSlash = YES;
        soap.requestTimeout = 10;
        soap.licenseKey = @"3hJP454la9UT4vl+7+imMyYa+BywnzS+SIsGTHAoE2lmyDY0vExuMYV8594krLhAl9/F69zo3LJTB6Wr0ZRuHQ==";
        
        [soap setIntegerValue:[VariaveisGlobais shared]._codEmpresa forKey:@"COD_EMPRESA"];
        [soap setIntegerValue:[VariaveisGlobais shared]._codUnidade forKey:@"COD_FILIAL"];
        [soap setIntegerValue:[VariaveisGlobais shared]._codAgendamento forKey:@"COD_AGENDAMENTO"];
        [soap requestURL:@"http://www.gestaospa.com.br/PROD/WebSrv/WebServiceGestao.asmx"
              soapAction:@"http://www.gestaospa.com.br/PROD/WebSrv/GET_AGENDAMENTO"
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
    return 7;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if(section == 4)
    {
        if (self.showProfessional) {
            return 1;
        } else {
            return 0;
        }
    }
    else
    {
        return 1;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}

-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSArray<NSString*> *identifiers = @[@"cellUnidade", @"cellServico", @"cellData",@"cellEscolha",@"cellProfissional",@"cellHorario",@"cellBotao"];
    
    NSString *strDataAgendamento;
    
    if([VariaveisGlobais shared]._dataAgendamento != nil)
    {
        NSDateFormatter *format = [[NSDateFormatter alloc] init];
        [format setDateFormat:@"dd/MM/yyyy"];
        strDataAgendamento = [format stringFromDate:[VariaveisGlobais shared]._dataAgendamento];
    }
    else
    {
        strDataAgendamento = [VariaveisGlobais shared]._dataAgendamento1;
    }
    
    NSArray<NSString*> *info = @[[VariaveisGlobais shared]._nomeFilial,
                                 [VariaveisGlobais shared]._servico ? [VariaveisGlobais shared]._servico : @"",
                                 strDataAgendamento ? strDataAgendamento : @"",
                                 @"",
                                 [VariaveisGlobais shared]._profissional ? [VariaveisGlobais shared]._profissional : @"",
                                 [VariaveisGlobais shared]._horarioAgendamento ? [VariaveisGlobais shared]._horarioAgendamento : @"",
                                 @""];
    
    if (indexPath.section == 3) {
        
        ShowProfessionalTableViewCell *cell = (ShowProfessionalTableViewCell*)[self.tableView dequeueReusableCellWithIdentifier:[identifiers objectAtIndex:indexPath.section] forIndexPath:indexPath];
        cell.delegate = self;
        return cell;
        
        
    } else if (indexPath.section == 6) {
        
        ScheduleTableViewCell *cell = (ScheduleTableViewCell*)[self.tableView dequeueReusableCellWithIdentifier:[identifiers objectAtIndex:indexPath.section] forIndexPath:indexPath];
        cell.delegate = self;
        return cell;
        
    } else {
        InfoTableViewCell *cell = (InfoTableViewCell*)[self.tableView dequeueReusableCellWithIdentifier:[identifiers objectAtIndex:indexPath.section] forIndexPath:indexPath];
        cell.infoLabel.text = [info objectAtIndex:indexPath.section];
        return cell;
    }
}

-(void)didSelect:(NSInteger)value {
    self.showProfessional = value == 0 ? YES : NO;
    
    [self limparHorarioAgendamento];
    
    if(value == YES)
    {
        [VariaveisGlobais shared]._withProfissional = 0;
    }
    else
    {
        [VariaveisGlobais shared]._withProfissional = 1;
        self.textProfissional.text = @"";
        [VariaveisGlobais shared]._profissional = nil;
    }
}
-(void)didPressScheduleButton{
    [self onclickAgendar:self];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"segueServico"])
    {
        if([VariaveisGlobais shared]._servico != nil)
        {
            [self limparTela];
            [VariaveisGlobais shared]._statusAgendamento = 0;
        }
    }
    
    if([segue.identifier isEqualToString:@"segueProfissional"] || [segue.identifier isEqualToString:@"segueData"] )
    {
        [self limparHorarioAgendamento];
        [VariaveisGlobais shared]._statusAgendamento = 0;
    }
}

@end

@interface ShowProfessionalTableViewCell()

@property (weak, nonatomic) IBOutlet UISegmentedControl *showProfessionalSegmentedControl;

@end

@implementation ShowProfessionalTableViewCell

- (IBAction)segmentedControlValueChanged:(UISegmentedControl *)sender {
    [self.delegate didSelect:sender.selectedSegmentIndex];
}

@end

@interface ScheduleTableViewCell()

@end

@implementation ScheduleTableViewCell

- (IBAction)scheduleButtonTap:(UIButton *)sender {
    
    [self.delegate didPressScheduleButton];
}

@end

@interface InfoTableViewCell()

@end

@implementation InfoTableViewCell

@end

