//
//  historicoAgendamento.h
//  gestaoSap
//
//  Created by User on 27/01/17.
//  Copyright © 2017 gntec. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface historicoAgendamento : NSObject
{
    NSInteger codAgendamento;
    NSInteger codProfissional;
    NSString *nomeProfissional;
    NSString *descricaoServico;
    NSNumber *valor;
    NSString *nomeCliente;
    NSString *msgRetorno;
    NSString *dataAgendametoServico;
    NSString *horaAgendamentoServico;
    NSString *statusServico;
}

@property(nonatomic) NSInteger codAgendamento;
@property(nonatomic) NSInteger codProfissional;
@property (nonatomic,strong) NSString *nomeProfissional;
@property (nonatomic,strong) NSString *descricaoServico;
@property (nonatomic,strong) NSNumber *valor;
@property (nonatomic,strong) NSString *nomeCliente;
@property (nonatomic,strong) NSString *msgRetorno;
@property (nonatomic,strong) NSString *dataAgendametoServico;
@property (nonatomic,strong) NSString *horaAgendamentoServico;
@property (nonatomic,strong) NSString *statusServico;

@end


//[{"COD_AGENDAMENTO":2388061,"PROFISSIONAL":{"COD_PROFISSIONAL":16,"NOME":"Marli"},"SERVICO":{"COD_SERVICO":5677,"DSC_SERVICO":"aplicação de enzima","VALOR":80},"CLIENTE":{"COD_CLIENTE":1055,"NOME":"Claudio Matteucci","MSG_RETORNO":""},"DATA":"27/01/2017","HORA":"08:00","STATUS":"PENDENTE"}
