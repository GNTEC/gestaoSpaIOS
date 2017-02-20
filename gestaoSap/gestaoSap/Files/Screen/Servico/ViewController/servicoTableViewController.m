//
//  servicoTableViewController.m
//  gestaoSap
//
//  Created by User on 18/01/17.
//  Copyright © 2017 gntec. All rights reserved.
//

#import "servicoTableViewController.h"

@interface servicoTableViewController ()
{
    LLARingSpinnerView *spinnerView;
}
@property (assign, nonatomic) BOOL updating;
@property (strong, nonatomic) LLARingSpinnerView *spinnerView;
@property (strong, nonatomic) NSMutableArray *arrayDataServico;

@end

@implementation servicoTableViewController

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

-(NSMutableArray *)arrayDataServico {
    if (!_arrayDataServico) {
        _arrayDataServico = [[NSMutableArray alloc] init];
    }
    return _arrayDataServico;
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
    [self servicos];
}

- (void) viewWillAppear:(BOOL)animated
{
    
    if(spinnerView.isAnimating)
    {
        [spinnerView stopAnimating];
        [spinnerView removeFromSuperview];
    }
    
}

-(void)servicos
{
    
    self.updating = true;
    
    //CHAMA A FUNÇÃO QUE FAZ O LOGIN
    [self getServicos:^(NSDictionary *dict, NSError *error) {
        
        NSMutableArray *arrayDataServico1 = [[NSMutableArray alloc] init];
        arrayDataServico1 = [dict objectForKey:@"ViewServico"];
            
        if (arrayDataServico1.count != 0)
        {
            for(int i = 0; i < [arrayDataServico1 count]; ++i)
            {
                servico *objServico = [[servico alloc]init];
                
                objServico.codServico = [[[arrayDataServico1 objectAtIndex:i]objectForKey:@"COD_SERVICO"] integerValue];
                objServico.descricaoServico = [[arrayDataServico1 objectAtIndex:i]objectForKey:@"DSC_SERVICO"];
                objServico.valor = [[arrayDataServico1 objectAtIndex:i]objectForKey:@"VALOR"];
                
                [self.arrayDataServico  addObject:objServico];
                
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableServico reloadData];
                self.updating = false;
            });
        }
        else
        {
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"ERRO" message:@"Não Existe Serciços disponiveis !" preferredStyle:UIAlertControllerStyleAlert];
            
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.arrayDataServico count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    servico *stServico = [self.arrayDataServico objectAtIndex:indexPath.row];
    
    cell.textLabel.text = stServico.descricaoServico;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    servico *stServico = [self.arrayDataServico objectAtIndex:indexPath.row];
    
    [VariaveisGlobais shared]._codServico = stServico.codServico;
    [VariaveisGlobais shared]._servico = stServico.descricaoServico;
    
    [self performSegueWithIdentifier:@"back" sender:self];
}

- (void)getServicos:(void(^)(NSDictionary *dict, NSError *error))block
{
    if (block) {
        SOAPEngine *soap = [[SOAPEngine alloc]init];
        soap.actionNamespaceSlash = YES;
        soap.requestTimeout = 10;
        soap.licenseKey = @"3hJP454la9UT4vl+7+imMyYa+BywnzS+SIsGTHAoE2lmyDY0vExuMYV8594krLhAl9/F69zo3LJTB6Wr0ZRuHQ==";
        
        [soap setIntegerValue:[VariaveisGlobais shared]._codEmpresa forKey:@"COD_EMPRESA"];
        [soap setIntegerValue:[VariaveisGlobais shared]._codUnidade forKey:@"COD_FILIAL"];
        [soap requestURL:@"http://www.gestaospa.com.br/PROD/WebSrv/WebServiceGestao.asmx"
              soapAction:@"http://www.gestaospa.com.br/PROD/WebSrv/GET_SERVICOS"
  completeWithDictionary:^(NSInteger statusCode, NSDictionary *dict) {
      
      block(dict, nil);
      
      } failWithError:^(NSError *error) {
          block(nil, error);
      }];
            
    }
}


@end
