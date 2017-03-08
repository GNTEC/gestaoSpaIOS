//
//  CadastreseViewController.h
//  gestaoSap
//
//  Created by User on 08/03/17.
//  Copyright © 2017 gntec. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CadastreseViewController : UIViewController <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *textNome;

@property (weak, nonatomic) IBOutlet UITextField *textSobreNome;
@property (weak, nonatomic) IBOutlet UITextField *textSenha;

@property (weak, nonatomic) IBOutlet UITextField *textEmail;

@end
