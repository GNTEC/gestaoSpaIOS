//
//  profissionalTableViewController.m
//  gestaoSap
//
//  Created by User on 19/01/17.
//  Copyright © 2017 gntec. All rights reserved.
//

#import "profissionalTableViewController.h"

@interface profissionalTableViewController ()
{

}

@property (assign, nonatomic) BOOL updating;
@property (strong, nonatomic) LLARingSpinnerView *spinnerView;
@property (strong, nonatomic) NSMutableArray *arrayDataProfissional;

@end

@implementation profissionalTableViewController
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
-(NSMutableArray *)arrayDataProfissional {
    if (!_arrayDataProfissional) {
        _arrayDataProfissional = [[NSMutableArray alloc] init];
    }
    return _arrayDataProfissional;
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
    [self profissionais];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)profissionais
{
    self.updating = true;
    //CHAMA A FUNÇÃO QUE FAZ O LOGIN
    [self getProfissionais:^(NSDictionary *dict, NSError *error) {
        
        if (dict.count > 0) {
            
            NSMutableArray *arrayDataServico1 = [[NSMutableArray alloc] init];
            arrayDataServico1 = [dict objectForKey:@"array"];
            
            
            for(int i = 0; i < [arrayDataServico1 count]; ++i)
            {
                profissional *objProfissional = [[profissional alloc]init];
                
                objProfissional.codProfissional = [[[arrayDataServico1 objectAtIndex:i]objectForKey:@"COD_PROFISSIONAL"] integerValue];
                objProfissional.nomeProfissional = [[arrayDataServico1 objectAtIndex:i]objectForKey:@"NOME"];
                
                [self.arrayDataProfissional  addObject:objProfissional];
                
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableProfissional reloadData];
                self.updating = false;
            });
        }
        else
        {
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"ERRO" message:@"Não Existe Profissionais disponiveis !" preferredStyle:UIAlertControllerStyleAlert];
            
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
    return [self.arrayDataProfissional count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    profissional *stProfissional = [self.arrayDataProfissional objectAtIndex:indexPath.row];
    
    cell.textLabel.text = stProfissional.nomeProfissional;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    profissional *stProfissional = [self.arrayDataProfissional objectAtIndex:indexPath.row];
    [VariaveisGlobais shared]._codProfissional = stProfissional.codProfissional;
    [VariaveisGlobais shared]._profissional = stProfissional.nomeProfissional;
    
    UITabBarController *tbc = [self.storyboard instantiateViewControllerWithIdentifier:@"MainTabBar"];
    tbc.selectedIndex=0;
    [self presentViewController:tbc animated:YES completion:nil];
}

- (void)getProfissionais:(void(^)(NSDictionary *dict, NSError *error))block
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
        [soap setIntegerValue:[VariaveisGlobais shared]._codServico forKey:@"COD_SERVICO"];
        [soap setValue:strData forKey:@"DATA_AGENDA"];
        [soap requestURL:@"http://www.gestaospa.com.br/PROD/WebSrv/WebServiceGestao.asmx"
              soapAction:@"http://www.gestaospa.com.br/PROD/WebSrv/GET_PROFISSIONAIS_2"
  completeWithDictionary:^(NSInteger statusCode, NSDictionary *dict) {
      
      block(dict, nil);
      
      } failWithError:^(NSError *error) {
          block(nil, error);
      }];
        
    }
}



@end
