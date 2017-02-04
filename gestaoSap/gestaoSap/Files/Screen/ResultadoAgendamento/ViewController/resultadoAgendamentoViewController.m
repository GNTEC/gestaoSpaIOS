//
//  resultadoAgendamentoViewController.m
//  gestaoSap
//
//  Created by User on 03/02/17.
//  Copyright © 2017 gntec. All rights reserved.
//

#import "resultadoAgendamentoViewController.h"


@interface resultadoAgendamentoViewController ()
{

}
@property (assign, nonatomic) BOOL updating;
@property (strong, nonatomic) LLARingSpinnerView *spinnerView;

@end

@implementation resultadoAgendamentoViewController
@synthesize codAgendamento;

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
            NSArray *cliente = [dict allValues][6];
            
            //status = 0
            //data = 1
            //profissional = 2
            //codagendamento = 3
            //hora = 4
            //servico = 5
            //cliente = 6
            //[servico valueForKey:@"VALOR"];
            
            self.labelCodAgendamento.text = [dict allValues][3];
            self.labelProfissional.text = [profissional valueForKey:@"NOME"];
            self.labelDescricaoServico.text = [servico valueForKey:@"DSC_SERVICO"];
            
            float valor = [[servico valueForKey:@"VALOR"]  floatValue];
            NSString *valorFormatado = [n stringFromNumber:[NSNumber numberWithFloat:valor]];
            self.labelValor.text = valorFormatado;
            
            self.labelNomeCliente.text = [cliente valueForKey:@"NOME"];
            self.labelData.text = [dict allValues][1];
            self.labelHorario.text = [dict allValues][4];
            self.labelStatus.text = [dict allValues][1];
            
//            }
//            dispatch_async(dispatch_get_main_queue(), ^{
//                self.updating = NO;
//            });
        }
        else
        {
            self.updating = NO;
            
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Erro" message:@"Erro no Agendamento do Serviço !" preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
            [alertController addAction:ok];
            
            [self presentViewController:alertController animated:YES completion:nil];
            
//            dispatch_async(dispatch_get_main_queue(), ^{
//                UIViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"agendaTableViewController"];
//                [self presentViewController:vc animated:YES completion:nil];
//                        });
            
            self.updating = false;
        }
    }];

    self.updating = false;
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

- (void)getAgendamentos:(void(^)(NSDictionary *dict, NSError *error))block
{
    
//    <web:GET_AGENDAMENTO_2>
//    <web:COD_EMPRESA>?</web:COD_EMPRESA>
//    <web:COD_FILIAL>?</web:COD_FILIAL>
//    <web:COD_AGENDAMENTO>?</web:COD_AGENDAMENTO>
//    </web:GET_AGENDAMENTO_2>
    
    if (block) {
        SOAPEngine *soap = [[SOAPEngine alloc]init];
        soap.actionNamespaceSlash = YES;
        soap.requestTimeout = 10;
        soap.licenseKey = @"3hJP454la9UT4vl+7+imMyYa+BywnzS+SIsGTHAoE2lmyDY0vExuMYV8594krLhAl9/F69zo3LJTB6Wr0ZRuHQ==";
        
        [soap setIntegerValue:[VariaveisGlobais shared]._codEmpresa forKey:@"COD_EMPRESA"];
        [soap setIntegerValue:[VariaveisGlobais shared]._codUnidade forKey:@"COD_FILIAL"];
        [soap setIntegerValue:self.codAgendamento forKey:@"COD_AGENDAMENTO"];
        [soap requestURL:@"http://www.gestaospa.com.br/PROD/WebSrv/WebServiceGestao.asmx"
              soapAction:@"http://www.gestaospa.com.br/PROD/WebSrv/GET_AGENDAMENTO"
  completeWithDictionary:^(NSInteger statusCode, NSDictionary *dict) {
      
      block(dict, nil);
      
  } failWithError:^(NSError *error) {
      block(nil, error);
  }];
        
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
