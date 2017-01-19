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
@property (strong, nonatomic) NSMutableArray *arrayDataProfissional;

@end

@implementation profissionalTableViewController

-(NSMutableArray *)arrayDataProfissional {
    if (!_arrayDataProfissional) {
        _arrayDataProfissional = [[NSMutableArray alloc] init];
    }
    return _arrayDataProfissional;
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
    
    [self  profissionais];
    
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

-(void)profissionais
{
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
            });
        }
        else
        {
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Erro" message:@"Não existe Unidade cadastrada !" preferredStyle:UIAlertControllerStyleAlert];
            
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
