//
//  servicoTableViewController.h
//  gestaoSap
//
//  Created by User on 18/01/17.
//  Copyright © 2017 gntec. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SOAPEngine64/SOAPEngine.h>
#import "VariaveisGlobais.h"
#import <LLARingSpinnerView/LLARingSpinnerView.h>
#import "servico.h"

@interface servicoTableViewController : UITableViewController


@property (strong, nonatomic) IBOutlet UITableView *tableServico;

@end
