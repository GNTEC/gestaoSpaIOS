//
//  UnidadeViewController.h
//  gestaoSap
//
//  Created by User on 10/01/17.
//  Copyright © 2017 gntec. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface unidadeViewController : UIViewController <UIPickerViewDelegate,UIPickerViewDataSource>

@property (weak, nonatomic) IBOutlet UIPickerView *pkcUnidade;


@end
