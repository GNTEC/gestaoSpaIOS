//
//  loginViewController.h
//  gestaoSap
//
//  Created by User on 26/12/16.
//  Copyright © 2016 gntec. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface loginViewController : UIViewController <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *textEmail;
@property (weak, nonatomic) IBOutlet UITextField *textSenha;


@end
