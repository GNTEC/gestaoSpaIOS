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
    
    if(self.stHistoricoAgendamento.codAgendamento != 0)
    {
        self.labelCodAgendamento.text = [@(self.stHistoricoAgendamento.codAgendamento) stringValue];
        self.labelProfissional.text = self.stHistoricoAgendamento.nomeProfissional;
        self.labelDescricaoServico.text= self.stHistoricoAgendamento.descricaoServico;
        self.labelValor.text = [self.stHistoricoAgendamento.valor stringValue];
        self.labelNomeCliente.text = self.stHistoricoAgendamento.nomeCliente;
        self.labelData.text = self.stHistoricoAgendamento.dataAgendametoServico;
        self.labelHorario.text = self.stHistoricoAgendamento.horaAgendamentoServico;
        self.labelStatus.text = self.stHistoricoAgendamento.statusServico;
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
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
