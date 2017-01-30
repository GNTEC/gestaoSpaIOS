//
//  historicoAgendamentoTableViewController.m
//  gestaoSap
//
//  Created by User on 27/01/17.
//  Copyright © 2017 gntec. All rights reserved.
//

#import "historicoAgendamentoTableViewController.h"
#import "JSONKit.h"

@interface historicoAgendamentoTableViewController ()
{

}
@property (strong, nonatomic) NSMutableArray *arrayDataHistoricoServico;

@end

@implementation historicoAgendamentoTableViewController
-(NSMutableArray *)arrayDataHistoricoServico {
    if (!_arrayDataHistoricoServico) {
        _arrayDataHistoricoServico = [[NSMutableArray alloc] init];
    }
    return _arrayDataHistoricoServico;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void) viewWillAppear:(BOOL)animated
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
    
    [self  historicoAgendamentos];
    
    if(spinnerView.isAnimating)
    {
        [spinnerView stopAnimating];
        [spinnerView removeFromSuperview];
    }
}


/*
- (void)fetchedData
{
    
    //NSError* error;
    //NSDictionary *document = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:&error];
    
    // all titre:video for album_titre:publicite
    NSArray *albumArray = [document objectForKey:@"album"];
    NSDictionary *dict = [albumArray objectAtindex:0];
    NSArray *videos = [dict objectForKey:@"album_videos"];
    
    // to fetch Videos inside album_videos
    // here you will get al the videos inside key titre_video
    NSMutableArray *titreVideoArray = [[NSMutableArray alloc]init];
    for(int i=0; i< videos.count; i++){
        NSDictionary *dict = [videos objectAtindex:i];
        NSArray *titreVideos = [dict objectForKey:@"titre_video"];
        [titreVideoArray addObject: titreVideos];
    }
}

*/


-(void)historicoAgendamentos
{
    //CHAMA A FUNÇÃO QUE FAZ O LOGIN
    [self getHistoricoAgendamentos:^(NSDictionary *dict, NSError *error) {
        
        if (dict.count > 0)
        {
            
            NSArray *dataArray = [dict objectForKey:@"Agendamento"];
      
            for(int i = 0; i < [dataArray count]; ++i)
            {
               historicoAgendamento *objHistoricoAgendamento = [[historicoAgendamento alloc]init];
                
                NSDictionary *dataArrayProfissional = [dataArray objectAtIndex:i];
                NSArray *profissional = [dataArrayProfissional objectForKey:@"PROFISSIONAL"];
                
                NSDictionary *dataArrayServico = [dataArray objectAtIndex:i];
                NSArray *servico = [dataArrayServico objectForKey:@"SERVICO"];
                
                NSDictionary *dataArrayClientes = [dataArray objectAtIndex:i];
                NSArray *cliente = [dataArrayClientes objectForKey:@"CLIENTE"];
                
                objHistoricoAgendamento.codAgendamento = [[[dataArray objectAtIndex:i]objectForKey:@"COD_AGENDAMENTO"] integerValue];
                objHistoricoAgendamento.codProfissional = [[profissional valueForKey:@"COD_PROFISSIONAL"] integerValue];
                objHistoricoAgendamento.nomeProfissional = [profissional valueForKey:@"NOME"];
                
                objHistoricoAgendamento.descricaoServico = [servico valueForKey:@"DSC_SERVICO"];
                objHistoricoAgendamento.valor = [servico valueForKey:@"VALOR"];
                
                objHistoricoAgendamento.nomeCliente = [cliente valueForKey:@"NOME"];
                objHistoricoAgendamento.msgRetorno = [cliente valueForKey:@"MSG_RETORNO"];
                
                objHistoricoAgendamento.dataAgendametoServico = [[dataArray objectAtIndex:i]objectForKey:@"DATA"];
                objHistoricoAgendamento.horaAgendamentoServico = [[dataArray objectAtIndex:i]objectForKey:@"HORA"];
                objHistoricoAgendamento.statusServico = [[dataArray objectAtIndex:0]objectForKey:@"STATUS"];
                
                [self.arrayDataHistoricoServico  addObject:objHistoricoAgendamento];
                
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                //[self.tableServico reloadData];
            });
        }
        else
        {
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Erro" message:@"Não existe Serviços realozados !" preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
            [alertController addAction:ok];
            
            [self presentViewController:alertController animated:YES completion:nil];
            
        }
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 7;
}

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

- (void)getHistoricoAgendamentos:(void(^)(NSDictionary *dict, NSError *error))block
{
    if (block) {
        SOAPEngine *soap = [[SOAPEngine alloc]init];
        soap.actionNamespaceSlash = YES;
        soap.requestTimeout = 10;
        soap.licenseKey = @"3hJP454la9UT4vl+7+imMyYa+BywnzS+SIsGTHAoE2lmyDY0vExuMYV8594krLhAl9/F69zo3LJTB6Wr0ZRuHQ==";
        
        [soap setIntegerValue:[VariaveisGlobais shared]._codEmpresa forKey:@"COD_EMPRESA"];
        [soap setIntegerValue:[VariaveisGlobais shared]._codUnidade forKey:@"COD_FILIAL"];
        [soap setIntegerValue:[VariaveisGlobais shared]._codCliente forKey:@"COD_CLIENTE"];
        [soap requestURL:@"http://www.gestaospa.com.br/PROD/WebSrv/WebServiceGestao.asmx"
              soapAction:@"http://www.gestaospa.com.br/PROD/WebSrv/GET_AGENDAMENTOS"
  completeWithDictionary:^(NSInteger statusCode, NSDictionary *dict) {
      
      block(dict, nil);
      
  } failWithError:^(NSError *error) {
      block(nil, error);
  }];
        
    }
}


@end
