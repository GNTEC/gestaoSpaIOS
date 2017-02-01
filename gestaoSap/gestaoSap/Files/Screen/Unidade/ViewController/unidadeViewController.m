//
//  UnidadeViewController.m
//  gestaoSap
//
//  Created by User on 10/01/17.
//  Copyright © 2017 gntec. All rights reserved.
//

#import "unidadeViewController.h"
#import <SOAPEngine64/SOAPEngine.h>
#import "VariaveisGlobais.h"
#import <LLARingSpinnerView/LLARingSpinnerView.h>
#import "unidade.h"

@interface unidadeViewController ()
{

}

@property (strong, nonatomic) unidade *stUnidade;
@property (strong, nonatomic) NSMutableArray *pickUnidadeData;

@end

@implementation unidadeViewController

-(unidade *)stUnidade{
    
    NSInteger selectedIndex = [self.pkcUnidade selectedRowInComponent:0];
    return [_pickUnidadeData objectAtIndex:selectedIndex];
}

-(NSMutableArray *)pickUnidadeData {
    if (!_pickUnidadeData) {
        _pickUnidadeData = [[NSMutableArray alloc] init];
    }
    return _pickUnidadeData;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void) viewWillAppear:(BOOL)animated
{
    [self unidades];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)unidades
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
    
    
    //CHAMA A FUNÇÃO QUE FAZ O LOGIN
    [self getUnidades:^(NSDictionary *dict, NSError *error) {
        
        if (dict.count > 0) {
            
            NSMutableArray *_pickUnidadeData_1 = [[NSMutableArray alloc] init];
            _pickUnidadeData_1 = [dict objectForKey:@"FILIAL"];
            
            
            for(int i = 0; i < [_pickUnidadeData_1 count]; ++i)
            {
                unidade *objUnidade = [[unidade alloc]init];
                
                objUnidade.codFilial = [[[_pickUnidadeData_1 objectAtIndex:i]objectForKey:@"COD_FILIAL"] integerValue];
                objUnidade.nomeFilial = [[_pickUnidadeData_1 objectAtIndex:i]objectForKey:@"NOME_FILIAL"];
                objUnidade.enderecoFilial = [[_pickUnidadeData_1 objectAtIndex:i]objectForKey:@"ENDERECO"];
                
                [self.pickUnidadeData  addObject:objUnidade];
                
                self.pkcUnidade.hidden = false;
                
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.pkcUnidade reloadAllComponents];
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
    
    if(spinnerView.isAnimating)
    {
        [spinnerView stopAnimating];
        [spinnerView removeFromSuperview];
    }
}

#pragma "Picker"

// The number of columns of data
- (int)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

// The number of rows of data
- (int)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [_pickUnidadeData count];
}

// The data to return for the row and component (column) that's being passed in
- (NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{

    unidade *stUnidade = [_pickUnidadeData objectAtIndex:row];
    
    return stUnidade.nomeFilial;
    
}

- (IBAction)logar:(UIButton *)sender
{
    [VariaveisGlobais shared]._codUnidade = self.stUnidade.codFilial;
    [VariaveisGlobais shared]._nomeFilial = self.stUnidade.nomeFilial;
    [VariaveisGlobais shared]._enderecoFilial = self.stUnidade.enderecoFilial;

    UITabBarController *tbc = [self.storyboard instantiateViewControllerWithIdentifier:@"MainTabBar"];
    tbc.selectedIndex=0;
    [self presentViewController:tbc animated:YES completion:nil];
}


- (void)getUnidades:(void(^)(NSDictionary *dict, NSError *error))block
{
    if (block) {
        SOAPEngine *soap = [[SOAPEngine alloc]init];
        soap.actionNamespaceSlash = YES;
        soap.requestTimeout = 10;
        soap.licenseKey = @"3hJP454la9UT4vl+7+imMyYa+BywnzS+SIsGTHAoE2lmyDY0vExuMYV8594krLhAl9/F69zo3LJTB6Wr0ZRuHQ==";
        
        [soap setIntegerValue:[VariaveisGlobais shared]._codEmpresa forKey:@"COD_EMPRESA"];
        [soap requestURL:@"http://www.gestaospa.com.br/PROD/WebSrv/WebServiceGestao.asmx"
              soapAction:@"http://www.gestaospa.com.br/PROD/WebSrv/GET_UNIDADES_2"
  completeWithDictionary:^(NSInteger statusCode, NSDictionary *dict) {
      
      block(dict, nil);
      
  } failWithError:^(NSError *error) {
      block(nil, error);
  }];
        
    }
}



@end
