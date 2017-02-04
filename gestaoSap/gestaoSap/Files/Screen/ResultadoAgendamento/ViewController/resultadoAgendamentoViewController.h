//
//  resultadoAgendamentoViewController.h
//  gestaoSap
//
//  Created by User on 03/02/17.
//  Copyright © 2017 gntec. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <LLARingSpinnerView/LLARingSpinnerView.h>
#import <SOAPEngine64/SOAPEngine.h>
#import "VariaveisGlobais.h"
#import "historicoAgendamento.h"

@interface resultadoAgendamentoViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *labelCodAgendamento;

@property (weak, nonatomic) IBOutlet UILabel *labelProfissional;

@property (weak, nonatomic) IBOutlet UILabel *labelDescricaoServico;

@property (weak, nonatomic) IBOutlet UILabel *labelValor;

@property (weak, nonatomic) IBOutlet UILabel *labelNomeCliente;

@property (weak, nonatomic) IBOutlet UILabel *labelData;

@property (weak, nonatomic) IBOutlet UILabel *labelHorario;

@property (weak, nonatomic) IBOutlet UILabel *labelStatus;

@property (nonatomic) NSInteger codAgendamento;

@end
