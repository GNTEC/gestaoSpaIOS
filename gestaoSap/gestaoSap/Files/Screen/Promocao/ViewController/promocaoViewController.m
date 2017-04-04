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
@property (assign, nonatomic) BOOL updating;
@property (strong, nonatomic) LLARingSpinnerView *spinnerView;

@property (strong, nonatomic) NSString *strPromocao;
@end

@implementation promocaoViewController
-(LLARingSpinnerView *)spinnerView {
    if (!_spinnerView) {
        _spinnerView = [[LLARingSpinnerView alloc] initWithFrame:CGRectMake(0, 0, 250, 250)];
        _spinnerView.tintColor = [UIColor blackColor];
        // Optionally set the current progress
        _spinnerView.lineWidth = 1.5f;
        _spinnerView.hidesWhenStopped = YES;
    }
    return _spinnerView;
}

-(void)setUpdating:(BOOL)updating {
    _updating = updating;
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.updating) {
            [self.spinnerView startAnimating];
        } else {
            [self.spinnerView stopAnimating];
        }
    });
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];
    [self promocoes];
}

-(void) setupUI {
    
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:77/255.0 green:182/255.0 blue:172/255.0 alpha:1];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [self.navigationController.navigationBar
     setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    self.navigationController.navigationBar.translucent = NO;

    self.spinnerView.center = CGPointMake(CGRectGetMidX(self.view.bounds), CGRectGetMidY(self.view.bounds));
    //spinnerView.backgroundColor = [UIColor grayColor];
    // Add it as a subview
    [self.view addSubview:self.spinnerView];
    
}

-(void) updateUI
{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)promocoes
{
    self.updating = YES;
    
    //CHAMA A FUNÇÃO QUE FAZ O LOGIN
    [self getPromocao:^(NSString *strMsgPromocao, NSError *error) {
        
        if (![strMsgPromocao isEqual:nil]) {

            dispatch_async(dispatch_get_main_queue(), ^{
                self.textPromocao.text = strMsgPromocao;
                self.updating = NO;
            });
        }
        else
        {
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Erro" message:@"Não existe Promocões !" preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
            [alertController addAction:ok];
            
            [self presentViewController:alertController animated:YES completion:nil];
            
            self.updating = NO;
        }
    }];
}

- (void)getPromocao:(void(^)(NSString *dict, NSError *error))block
{
    if (block) {
        
        SOAPEngine *soap = [[SOAPEngine alloc]init];
        soap.actionNamespaceSlash = YES;
        soap.requestTimeout = 10;
        soap.licenseKey = @"whRGNkHH719j5474Q0yqdui4sXxBFFxlGXsyjt6510NzrXIUx2TYRaDdNeWb2j0W/l6cD/xiB2NHyq8tzUjyXQ==";
        
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
