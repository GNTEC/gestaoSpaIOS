//
//  promocaoViewController.m
//  gestaoSap
//
//  Created by User on 25/01/17.
//  Copyright © 2017 gntec. All rights reserved.
//

#import "promocaoViewController.h"

@interface promocaoViewController ()
{
}
@property (strong, nonatomic) NSString *strPromocao;
@end

@implementation promocaoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
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
    
    [self promocoes];
    
    if(spinnerView.isAnimating)
    {
        [spinnerView stopAnimating];
        [spinnerView removeFromSuperview];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)promocoes
{
    //CHAMA A FUNÇÃO QUE FAZ O LOGIN
    [self getPromocao:^(NSString *strMsgPromocao, NSError *error) {
        
        if (![strMsgPromocao isEqual:nil]) {

            dispatch_async(dispatch_get_main_queue(), ^{
                self.textPromocao.text = strMsgPromocao;
            });
        }
        else
        {
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Erro" message:@"Não existe Promocões !" preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
            [alertController addAction:ok];
            
            [self presentViewController:alertController animated:YES completion:nil];
            
        }
    }];
}

- (void)getPromocao:(void(^)(NSString *dict, NSError *error))block
{
    if (block) {
        
        SOAPEngine *soap = [[SOAPEngine alloc]init];
        soap.actionNamespaceSlash = YES;
        soap.requestTimeout = 10;
        soap.licenseKey = @"3hJP454la9UT4vl+7+imMyYa+BywnzS+SIsGTHAoE2lmyDY0vExuMYV8594krLhAl9/F69zo3LJTB6Wr0ZRuHQ==";
        
        [soap setIntegerValue:[VariaveisGlobais shared]._codEmpresa forKey:@"COD_EMPRESA"];
        [soap setIntegerValue:[VariaveisGlobais shared]._codUnidade forKey:@"COD_FILIAL"];
        [soap requestURL:@"http://www.gestaospa.com.br/PROD/WebSrv/WebServiceGestao.asmx"
              soapAction:@"http://www.gestaospa.com.br/PROD/WebSrv/GET_PROMOCOES"
        completeWithDictionary:^(NSInteger statusCode, NSDictionary *dict) {
      
            NSString *strMensagem = [soap stringValue];
            
      block(strMensagem, nil);
      
      } failWithError:^(NSError *error) {
          block(nil, error);
      }];
        
    }
}

@end
