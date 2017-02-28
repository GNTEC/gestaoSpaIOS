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
#import "unidadeViewController.h"

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
    [self getlogin:^(NSDictionary *dict, NSError *error) {
        
        NSString *msgRet = [dict objectForKey:@"MSG_RETORNO"];
        
        if ([msgRet isEqualToString:@"OK"]) {
            
            [VariaveisGlobais shared]._codEmpresa = COD_EMPRESA;
            [VariaveisGlobais shared]._codCliente = [[dict objectForKey:@"COD_CLIENTE"] integerValue];
             
            UIViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"unidadeViewController"];
            [self presentViewController:vc animated:YES completion:nil];
            
            NSLog(@"%@",msgRet);
        
            if(spinnerView.isAnimating)
            {
                [spinnerView stopAnimating];
                [spinnerView removeFromSuperview];
            }
        }
        
        else
        {
            if(msgRet == nil)
            {
                msgRet = @"Login não cadastrado";
            }
            
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Erro" message:msgRet preferredStyle:UIAlertControllerStyleAlert];
            
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


- (void)getlogin:(void(^)(NSDictionary *dict, NSError *error))block
{
    if (block) {
        SOAPEngine *soap = [[SOAPEngine alloc]init];
        soap.actionNamespaceSlash = YES;
        soap.requestTimeout = 10;
        soap.licenseKey = @"3hJP454la9UT4vl+7+imMyYa+BywnzS+SIsGTHAoE2lmyDY0vExuMYV8594krLhAl9/F69zo3LJTB6Wr0ZRuHQ==";
        
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
