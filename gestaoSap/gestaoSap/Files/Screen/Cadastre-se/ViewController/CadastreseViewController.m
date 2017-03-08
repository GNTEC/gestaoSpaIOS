//
//  CadastreseViewController.m
//  gestaoSap
//
//  Created by User on 08/03/17.
//  Copyright © 2017 gntec. All rights reserved.
//

#import "CadastreseViewController.h"
#import "VariaveisGlobais.h"
#import <LLARingSpinnerView/LLARingSpinnerView.h>
#import <MessageUI/MessageUI.h>

@interface CadastreseViewController ()

@property (strong, nonatomic)MFMailComposeViewController *mailer;

@end

@implementation CadastreseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)logar:(UIButton *)sender
{
    LLARingSpinnerView *spinnerView = [[LLARingSpinnerView alloc] initWithFrame:CGRectMake(0, 0, 250, 250)];
    spinnerView.tintColor = [UIColor blackColor];
    spinnerView.center = CGPointMake(CGRectGetMidX(self.view.bounds), CGRectGetMidY(self.view.bounds));
    
    // Optionally set the current progress
    spinnerView.lineWidth = 1.5f;
    
    // Add it as a subview
    [self.view addSubview:spinnerView];
    
    // Spin it
    [spinnerView startAnimating];

    //Verifica se a os campos foram preenchidos
    if([self.textNome.text  isEqual: @""])
    {
        // Stop animation
        if(spinnerView.isAnimating)
        {
            [spinnerView stopAnimating];
            [spinnerView removeFromSuperview];
        }
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"informação" message:@"Digite seu Nome !" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:ok];
        
        [self presentViewController:alertController animated:YES completion:nil];
        
        return;
    }
    
    //Verifica se a os campos foram preenchidos
    if([self.textNome.text  isEqual: @""])
    {
        // Stop animation
        if(spinnerView.isAnimating)
        {
            [spinnerView stopAnimating];
            [spinnerView removeFromSuperview];
        }
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"informação" message:@"Digite seu Nome !" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:ok];
        
        [self presentViewController:alertController animated:YES completion:nil];
        
        return;
    }
    
    //Verifica se a os campos foram preenchidos
    if([self.textSobreNome.text  isEqual: @""])
    {
        // Stop animation
        if(spinnerView.isAnimating)
        {
            [spinnerView stopAnimating];
            [spinnerView removeFromSuperview];
        }
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"informação" message:@"Digite seu Sobre Nome !" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:ok];
        
        [self presentViewController:alertController animated:YES completion:nil];
        
        return;
    }
    
    //Verifica se a os campos foram preenchidos
    if([self.textSenha.text  isEqual: @""])
    {
        
        // Stop animation
        if(spinnerView.isAnimating)
        {
            [spinnerView stopAnimating];
            [spinnerView removeFromSuperview];
        }
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"informação" message:@"Digite sua Senha !" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:ok];
        
        [self presentViewController:alertController animated:YES completion:nil];
        
        return;
    }
    
    //CHAMA A FUNÇÃO QUE FAZ O LOGIN
//    [self getlogin:^(NSDictionary *dict, NSError *error) {
//        
//        NSString *msgRet = [dict objectForKey:@"MSG_RETORNO"];
//        
//        if ([msgRet isEqualToString:@"OK"]) {
//            
//            [VariaveisGlobais shared]._codEmpresa = COD_EMPRESA;
//            [VariaveisGlobais shared]._codCliente = [[dict objectForKey:@"COD_CLIENTE"] integerValue];
//            
//            UIViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"unidadeViewController"];
//            [self presentViewController:vc animated:YES completion:nil];
//            
//            NSLog(@"%@",msgRet);
//            
//            if(spinnerView.isAnimating)
//            {
//                [spinnerView stopAnimating];
//                [spinnerView removeFromSuperview];
//            }
//        }
//        
//        else
//        {
//            if(msgRet == nil)
//            {
//                msgRet = @"Login não cadastrado";
//            }
//            
//            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Erro" message:msgRet preferredStyle:UIAlertControllerStyleAlert];
//            
//            UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
//            [alertController addAction:ok];
//            
//            [self presentViewController:alertController animated:YES completion:nil];
//            
//            if(spinnerView.isAnimating)
//            {
//                [spinnerView stopAnimating];
//                [spinnerView removeFromSuperview];
//            }
//        }
//    }];
}


//-(void) sendMailTo: (NSString *) recipient {
//    
//    self.mailer = [[MFMailComposeViewController alloc] init];
//    self.mailer.mailComposeDelegate = self;
//    
//    [self.mailer setSubject:@"My Fabolous Subject"];
//    
//    NSArray *toRecipients = [NSArray arrayWithObjects:recipient, nil];
//    [self.mailer setToRecipients:toRecipients];
//    
//    /* You might want to uncomment the following, if you
//     * have images to attach */
//    // UIImage *myImage = [UIImage imageNamed:@"myfabolousimage.png"];
//    // NSData *imageData = UIImagePNGRepresentation(myImage);
//    // [self.mailer addAttachmentData:imageData
//    //              mimeType:@"image/png" fileName:@"myfabolousimage.png"];
//    
//    NSString *emailBody = @"";
//    [self.mailer setMessageBody:emailBody isHTML:NO];
//    
//    [self presentViewController:self.mailer animated:YES completion:nil];
//    
//}

@end
