//
//  HistoricoTableViewCell.h
//  gestaoSap
//
//  Created by User on 01/02/17.
//  Copyright © 2017 gntec. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HistoricoTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *labelServico;

@property (weak, nonatomic) IBOutlet UILabel *labelProfissional;

@property (weak, nonatomic) IBOutlet UILabel *labelData;

@property (weak, nonatomic) IBOutlet UILabel *labelHora;

@property (weak, nonatomic) IBOutlet UILabel *labelStatus;

@end
