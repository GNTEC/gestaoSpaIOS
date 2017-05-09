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
            NSMutableArray *cliente = [[NSMutableArray alloc] init];
            cliente = [dict objectForKey:@"CLIENTE"];
            
            NSMutableArray *profissional = [[NSMutableArray alloc] init];
            profissional = [dict objectForKey:@"PROFISSIONAL"];
            
            NSMutableArray *servico = [[NSMutableArray alloc] init];
            servico = [dict objectForKey:@"SERVICO"];
            
            NSMutableArray *status = [[NSMutableArray alloc] init];
            status = [dict objectForKey:@"STATUS"];
            
            NSMutableArray *hora = [[NSMutableArray alloc] init];
            hora = [dict objectForKey:@"HORA"];
            
            NSMutableArray *data = [[NSMutableArray alloc] init];
            data = [dict objectForKey:@"DATA"];
            
            NSMutableArray *codAgendamento = [[NSMutableArray alloc] init];
            codAgendamento = [dict objectForKey:@"COD_AGENDAMENTO"];
            
            self.labelCodAgendamento.text = codAgendamento.description;
            self.labelProfissional.text = [profissional valueForKey:@"NOME"];
            self.labelDescricaoServico.text = [servico valueForKey:@"DSC_SERVICO"];
            
            float valor = [[servico valueForKey:@"VALOR"]  floatValue];
            NSString *valorFormatado = [n stringFromNumber:[NSNumber numberWithFloat:valor]];
            self.labelValor.text = valorFormatado;
            
            self.labelNomeCliente.text = [cliente valueForKey:@"NOME"];
            self.labelData.text = data.description;
            self.labelHorario.text = hora.description;
            self.labelStatus.text = status.description;
        }
        else
        {
            self.updating = NO;
            
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"ERRO" message:@"Houve uma erro a no Agendamento do Serviço !" preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                       handler:^(UIAlertAction * _Nonnull action) {
                                                           [self performSegueWithIdentifier:@"back" sender:self];
                                                       }];
            
            [alertController addAction:ok];
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

-(void)viewWillAppear:(BOOL)animated
{
//    [self setupUI];
//    [self updateUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)getAgendamentos:(void(^)(NSDictionary *dict, NSError *error))block
{
    if (block) {
        SOAPEngine *soap = [[SOAPEngine alloc]init];
        soap.actionNamespaceSlash = YES;
        soap.requestTimeout = 10;
        soap.licenseKey = @"whRGNkHH719j5474Q0yqdui4sXxBFFxlGXsyjt6510NzrXIUx2TYRaDdNeWb2j0W/l6cD/xiB2NHyq8tzUjyXQ==";

        [soap setIntegerValue:[VariaveisGlobais shared]._codEmpresa forKey:@"COD_EMPRESA"];
        [soap setIntegerValue:[VariaveisGlobais shared]._codUnidade forKey:@"COD_FILIAL"];
        [soap setIntegerValue:[VariaveisGlobais shared]._codAgendamento forKey:@"COD_AGENDAMENTO"];
        [soap requestURL:@"http://www.gestaospa.com.br/PROD/WebSrv/WebServiceGestao.asmx"
              soapAction:@"http://www.gestaospa.com.br/PROD/WebSrv/GET_AGENDAMENTO_2"
  completeWithDictionary:^(NSInteger statusCode, NSDictionary *dict) {

      block(dict, nil);

      } failWithError:^(NSError *error) {
          block(nil, error);
      }];
    }
}

@end
