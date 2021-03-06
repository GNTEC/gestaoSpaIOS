//
//  agendaTableViewController.h
//  gestaoSap
//
//  Created by User on 17/01/17.
//  Copyright © 2017 gntec. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SOAPEngine64/SOAPEngine.h>
#import "VariaveisGlobais.h"
#import <LLARingSpinnerView/LLARingSpinnerView.h>
#import "resultadoAgendamentoViewController.h"

@protocol ScheduleTableViewCellDelegate
-(void)didSelect:(NSInteger)value;
-(void)didPressScheduleButton;
@end

@interface agendaTableViewController : UITableViewController <ScheduleTableViewCellDelegate>

@property (weak, nonatomic) IBOutlet UILabel *textUnidade;

@property (weak, nonatomic) IBOutlet UILabel *textServico;

@property (weak, nonatomic) IBOutlet UILabel *textData;

@property (weak, nonatomic) IBOutlet UISegmentedControl *segProfissional;

@property (weak, nonatomic) IBOutlet UILabel *textProfissional;

@property (weak, nonatomic) IBOutlet UILabel *textHora;

@property (weak, nonatomic) IBOutlet UIButton *btnAgendar;

@property (weak, nonatomic) IBOutlet UITableViewCell *cellProfissional;

@end


@interface ShowProfessionalTableViewCell: UITableViewCell
@property (weak, nonatomic) UIViewController<ScheduleTableViewCellDelegate> *delegate;
@end

@interface ScheduleTableViewCell: UITableViewCell
@property (weak,nonatomic) UIViewController<ScheduleTableViewCellDelegate> *delegate;
@end

@interface InfoTableViewCell: UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *infoLabel;

@end
