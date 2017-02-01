//
//  historicoAgendamentoTableViewController.h
//  gestaoSap
//
//  Created by User on 27/01/17.
//  Copyright © 2017 gntec. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SOAPEngine64/SOAPEngine.h>
#import "VariaveisGlobais.h"
#import <LLARingSpinnerView/LLARingSpinnerView.h>
#import "historicoAgendamento.h"

@interface historicoAgendamentoTableViewController : UITableViewController

@property (strong, nonatomic) IBOutlet UITableView *tableHistorico;

@end
