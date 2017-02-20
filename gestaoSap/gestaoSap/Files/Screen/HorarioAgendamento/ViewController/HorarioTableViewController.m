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
@property (assign, nonatomic) BOOL updating;
@property (strong, nonatomic) LLARingSpinnerView *spinnerView;
@property (strong, nonatomic) NSMutableArray *arrayDataHorario;

@end

@implementation HorarioTableViewController
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
-(NSMutableArray *)arrayDataHorario {
    if (!_arrayDataHorario) {
        _arrayDataHorario = [[NSMutableArray alloc] init];
    }
    return _arrayDataHorario;
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
    if([VariaveisGlobais shared]._withProfissional == YES)
    {
        [self horariosLivres];
    }
    else
    {
        [self horarios];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];
    [self updateUI];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)horariosLivres
{
    self.updating = YES;
    //CHAMA A FUNÇÃO QUE FAZ O LOGIN
    [self getHorariosLivres:^(NSDictionary *dict, NSError *error) {
        
        NSMutableArray *arrayDataServico1 = [[NSMutableArray alloc] init];
        arrayDataServico1 = [dict objectForKey:@"array"];
        
        if (arrayDataServico1.count != 0)
        {
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
                self.updating = false;
            });
        }
        else
        {
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"ERRO" message:@"Não Existe Horarios Disponiveis !" preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                       handler:^(UIAlertAction * _Nonnull action) {
                                                           [self performSegueWithIdentifier:@"back" sender:self];
                                                       }];
            
            [alertController addAction:ok];
            
            [self presentViewController:alertController animated:YES completion:nil];
            self.updating = false;
        }
    }];
}

-(void)horarios
{
    self.updating = YES;
    //CHAMA A FUNÇÃO QUE FAZ O LOGIN
    [self getHorarios:^(NSDictionary *dict, NSError *error) {
        
        NSMutableArray *arrayDataServico1 = [[NSMutableArray alloc] init];
        arrayDataServico1 = [dict objectForKey:@"array"];
            
        if (arrayDataServico1.count != 0)
        {
        
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
                self.updating = false;
            });
        }
        else
        {
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"ERRO" message:@"Não Existe Horários disponiveis !" preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                       handler:^(UIAlertAction * _Nonnull action) {
                                                           [self performSegueWithIdentifier:@"back" sender:self];
                                                       }];
            
            [alertController addAction:ok];
            
            [self presentViewController:alertController animated:YES completion:nil];
            self.updating = false;
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
    
    [self performSegueWithIdentifier:@"back" sender:self];
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

- (void)getHorariosLivres:(void(^)(NSDictionary *dict, NSError *error))block
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
        [soap requestURL:@"http://www.gestaospa.com.br/PROD/WebSrv/WebServiceGestao.asmx"
              soapAction:@"http://www.gestaospa.com.br/PROD/WebSrv/GET_HORARIO_LIVRE_2"
  completeWithDictionary:^(NSInteger statusCode, NSDictionary *dict) {
      
      block(dict, nil);
      
  } failWithError:^(NSError *error) {
      block(nil, error);
  }];
        
    }
}

@end
