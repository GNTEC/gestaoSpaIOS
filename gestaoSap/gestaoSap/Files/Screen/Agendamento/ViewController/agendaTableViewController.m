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
    
    self.textUnidade.text = [VariaveisGlobais shared]._nomeFilial;
    self.textServico.text = [VariaveisGlobais shared]._servico;
    self.textProfissional.text = [VariaveisGlobais shared]._profissional;
    self.textHora.text = [VariaveisGlobais shared]._horarioAgendamento;
    
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"dd/MM/yyyy"];
    NSString *strDataAgendamento = [format stringFromDate:[VariaveisGlobais shared]._dataAgendamento];
    
    self.textData.text = strDataAgendamento;
    self.showProfessional = YES;
    
    self.spinnerView.center = CGPointMake(CGRectGetMidX(self.view.bounds), CGRectGetMidY(self.view.bounds));
    
    //self.spinnerView.center = self.view.center;
    [self.view addSubview:self.spinnerView];
}

-(void) updateUI
{
    [self.tableView reloadData];
    
    if([VariaveisGlobais shared]._withProfissional == YES)
    {
        
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
        
        NSString *strMensagemRetorno;
        
        if (dict.count > 0) {
            
            NSInteger codAgendamento = [[dict objectForKey:@"COD_AGENDAMENTO"] integerValue];
            strMensagemRetorno = [dict objectForKey:@"MSG_RETORNO"];

            if(codAgendamento != 0)
            {
                [VariaveisGlobais shared]._codAgendamento = 0;
                [VariaveisGlobais shared]._codAgendamento = codAgendamento;
                
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
        
        //DATA
        NSDateFormatter *format = [[NSDateFormatter alloc] init];
        [format setDateFormat:@"dd/MM/yyyy"];
        NSString *strDataAgendamento = [format stringFromDate:[VariaveisGlobais shared]._dataAgendamento];
        
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
        
        [soap setIntegerValue:[VariaveisGlobais shared]._codEmpresa forKey:@"COD_EMPRESA"];
        [soap setIntegerValue:[VariaveisGlobais shared]._codUnidade forKey:@"COD_FILIAL"];
        [soap setIntegerValue:0 forKey:@"COD_AGENDAMENTO"];
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
    
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"dd/MM/yyyy"];
    NSString *strDataAgendamento = [format stringFromDate:[VariaveisGlobais shared]._dataAgendamento];
    
    
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
    [VariaveisGlobais shared]._withProfissional = value;
}

-(void)didPressScheduleButton{
    [self onclickAgendar:self];
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
