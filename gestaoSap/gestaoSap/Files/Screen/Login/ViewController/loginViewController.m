//
//  loginViewController.m
//  gestaoSap
//
//  Created by User on 26/12/16.
//  Copyright © 2016 gntec. All rights reserved.
//

#import "loginViewController.h"
#import <SOAPEngine64/SOAPEngine.h>
#import "VariaveisGlobais.h"
#import <LLARingSpinnerView/LLARingSpinnerView.h>
#import "agendamentoViewController.h"

static const int COD_EMPRESA = 58 ;

@interface loginViewController ()
{

}
@property (nonatomic, strong) SOAPEngine *soap;

@end

@implementation loginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.textEmail.delegate = self;
    self.textSenha.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(BOOL) textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    return YES;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    [self.textSenha resignFirstResponder];
    [self.textEmail resignFirstResponder];
}


//- (IBAction)start:(UIButton *)sender w
- (IBAction)logar:(UIButton *)sender
{
    LLARingSpinnerView *spinnerView = [[LLARingSpinnerView alloc] initWithFrame:CGRectMake(0, 0, 250, 250)];
    spinnerView.tintColor = [UIColor blackColor];
    spinnerView.center = CGPointMake(CGRectGetMidX(self.view.bounds), CGRectGetMidY(self.view.bounds));
    //spinnerView.backgroundColor = [UIColor grayColor];
    
    // Optionally set the current progress
    spinnerView.lineWidth = 1.5f;
    
    // Add it as a subview
    [self.view addSubview:spinnerView];
    
    // Spin it
    [spinnerView startAnimating];
    
    //Verifica se a os campos foram preenchidos
    if([_textEmail.text  isEqual: @""])
    {
        // Stop animation
        if(spinnerView.isAnimating)
        {
            [spinnerView stopAnimating];
            [spinnerView removeFromSuperview];
        }
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"informação" message:@"Digite seu E-Mail !" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:ok];
        
        [self presentViewController:alertController animated:YES completion:nil];
        
        return;
    }
    
    //Verifica se a os campos foram preenchidos
    if([_textSenha.text  isEqual: @""])
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
    [self login:^(NSDictionary *dict, NSError *error) {
        
        NSString *msgRet = [dict objectForKey:@"MSG_RETORNO"];
        
        if ([msgRet isEqualToString:@"OK"]) {
         
            UITabBarController *tbc = [self.storyboard instantiateViewControllerWithIdentifier:@"MainTabBar"];
            tbc.selectedIndex=0;
            [self presentViewController:tbc animated:YES completion:nil];
            
            NSLog(@"%@",msgRet);
            
            if(spinnerView.isAnimating)
            {
                [spinnerView stopAnimating];
                [spinnerView removeFromSuperview];
            }
        }
        
        else
        {
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Erro" message:@"Erro ao Fazer o Login !" preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
            [alertController addAction:ok];
            
            [self presentViewController:alertController animated:YES completion:nil];
            
             NSLog(@"%@",msgRet);
            
            if(spinnerView.isAnimating)
            {
                [spinnerView stopAnimating];
                [spinnerView removeFromSuperview];
            }
        }
    }];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)login:(void(^)(NSDictionary *dict, NSError *error))block
{
    if (block) {
        SOAPEngine *soap = [[SOAPEngine alloc]init];
        soap.actionNamespaceSlash = YES;
        //soap.version= VERSION_WCF_1_1;
        soap.requestTimeout = 10;
        //soap.responseHeader = YES;
        
        [soap setIntegerValue:COD_EMPRESA forKey:@"COD_EMPRESA"];
        [soap setValue: self.textEmail.text forKey:@"usr"];
        [soap setValue: self.textSenha.text forKey:@"password"];
        [soap requestURL:@"http://www.gestaospa.com.br/PROD/WebSrv/WebServiceGestao.asmx"
              soapAction:@"http://www.gestaospa.com.br/PROD/WebSrv/LOGIN_3"
  completeWithDictionary:^(NSInteger statusCode, NSDictionary *dict) {
      
      block(dict, nil);
      
  } failWithError:^(NSError *error) {
      block(nil, error);
  }];
        
    }
}

@end
