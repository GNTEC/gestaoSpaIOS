//
//  HistoricoAgendamentoDetalheViewController.m
//  gestaoSap
//
//  Created by User on 01/02/17.
//  Copyright © 2017 gntec. All rights reserved.
//

#import "HistoricoAgendamentoDetalheViewController.h"


@interface HistoricoAgendamentoDetalheViewController ()
{

}

@property (assign, nonatomic) BOOL updating;
@property (strong, nonatomic) LLARingSpinnerView *spinnerView;
@property (nonatomic) NSInteger statusAgendamento;

@end

@implementation HistoricoAgendamentoDetalheViewController
@synthesize stHistoricoAgendamento;

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
    
    if(self.stHistoricoAgendamento.codAgendamento != 0)
    {
        self.labelCodAgendamento.text = [@(self.stHistoricoAgendamento.codAgendamento) stringValue];
        self.labelProfissional.text = self.stHistoricoAgendamento.nomeProfissional;
        self.labelDescricaoServico.text= self.stHistoricoAgendamento.descricaoServico;
    
        float valor = [self.stHistoricoAgendamento.valor  floatValue];
        NSString *valorFormatado = [n stringFromNumber:[NSNumber numberWithFloat:valor]];
        self.labelValor.text = valorFormatado;
        
        self.labelNomeCliente.text = self.stHistoricoAgendamento.nomeCliente;
        self.labelData.text = self.stHistoricoAgendamento.dataAgendametoServico;
        self.labelHorario.text = self.stHistoricoAgendamento.horaAgendamentoServico;
        self.labelStatus.text = self.stHistoricoAgendamento.statusServico;
        
        if([self.labelStatus.text isEqualToString:@"CONFIRMADO"] || [self.labelStatus.text isEqualToString:@"DESMARCADO"])
        {
            self.sgnGerenciar.selectedSegmentIndex = 0;
            self.sgnGerenciar.enabled = false;
            //self.sgnGerenciar.alpha = 0;
            self.btnOk.enabled = false;
            self.btnOk.alpha = 0.5;
        }
    }
    else
    {
        self.updating = false;
    }
    
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

- (IBAction)onClick:(UIButton *)sender
{
    //        <web:COD_EMPRESA>?</web:COD_EMPRESA>
    //        <web:COD_FILIAL>?</web:COD_FILIAL>
    //        <web:COD_AGENDAMENTO>?</web:COD_AGENDAMENTO>
    //        <web:Status>?</web:Status>
    
    //    }else if(selecaoSpinner.equals("Cancelar")){
    //        status = 0;
    //        setStatusAgendamento();
    //
    //    }else if(selecaoSpinner.equals("Confirmar")){
    //        status = 1;
    //        setStatusAgendamento();
    //
    //    }else if(selecaoSpinner.equals("Alterar")){
    //        status = 2;
    
    
    self.updating = true;
    
    if(self.sgnGerenciar.selectedSegmentIndex == 0)
    {
        self.statusAgendamento = 1;
    }
    else if (self.sgnGerenciar.selectedSegmentIndex == 1)
    {
        self.statusAgendamento = 2;
    }
    
    else if (self.sgnGerenciar.selectedSegmentIndex == 2)
    {
        self.statusAgendamento = 0;
    }

    //CHAMA A FUNÇÃO QUE FAZ O LOGIN
    [self changeStatusAgendamento:^(NSString *strMsgPromocao, NSError *error) {
        
        if (![strMsgPromocao isEqual:nil]) {
            
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"OK" message:strMsgPromocao preferredStyle:UIAlertControllerStyleAlert];
            
            
            UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                handler:^(UIAlertAction * _Nonnull action) {
                                    [self performSegueWithIdentifier:@"back" sender:self];
                                }];
            
            [alertController addAction:ok];
            
            [self presentViewController:alertController animated:YES completion:nil];
            self.updating = false;

        }
        else
        {
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Erro" message:@"Erro ao na Aleração do Status !" preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
            [alertController addAction:ok];
            
            [self presentViewController:alertController animated:YES completion:nil];
            self.updating = false;
        }
    }];
}

- (void)changeStatusAgendamento:(void(^)(NSString *dict, NSError *error))block
{
    if (block) {
        
        SOAPEngine *soap = [[SOAPEngine alloc]init];
        soap.actionNamespaceSlash = YES;
        soap.requestTimeout = 10;
        soap.licenseKey = @"3hJP454la9UT4vl+7+imMyYa+BywnzS+SIsGTHAoE2lmyDY0vExuMYV8594krLhAl9/F69zo3LJTB6Wr0ZRuHQ==";
        
        [soap setIntegerValue:[VariaveisGlobais shared]._codEmpresa forKey:@"COD_EMPRESA"];
        [soap setIntegerValue:[VariaveisGlobais shared]._codUnidade forKey:@"COD_FILIAL"];
        [soap setIntegerValue:[self.labelCodAgendamento.text intValue]  forKey:@"COD_AGENDAMENTO"];
        [soap setIntegerValue:self.statusAgendamento forKey:@"Status"];
        [soap requestURL:@"http://www.gestaospa.com.br/PROD/WebSrv/WebServiceGestao.asmx"
              soapAction:@"http://www.gestaospa.com.br/PROD/WebSrv/SET_AGENDAMENTO_STATUS_2"
  completeWithDictionary:^(NSInteger statusCode, NSDictionary *dict) {
      
          NSString *strMensagem = [soap stringValue];
      
          block(strMensagem, nil);
      
  } failWithError:^(NSError *error) {
      block(nil, error);
  }];
        
    }
}

@end
