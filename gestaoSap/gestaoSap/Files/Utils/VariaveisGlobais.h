//
//  VariaveisGlobais.h
//  AZB_ATEC
//
//  Created by ASTRAZENECA ISIT on 14/01/14.
//  Copyright (c) 2014 Marcelo Pavani. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VariaveisGlobais : NSObject

{
    NSInteger _codCliente;
    NSInteger _codEmpresa;
    NSInteger _codUnidade;
    NSString  *_nomeFilial;
    NSString  *_enderecoFilial;
    NSInteger _codServico;
    NSString *_servico;
    NSDate   *_dataAgendamento;
    NSString *_dataAgendamento1;
    NSInteger _codProfissional;
    NSString *_profissional;
    NSString *_horarioAgendamento;
    NSInteger _codAgendamento;
    BOOL _withProfissional;
    NSInteger _statusAgendamento;

}

//variavel que vai controlar se devemos pedir mais tempo para tarefa em background ou não
@property(nonatomic)NSInteger _codCliente;
@property(nonatomic)NSInteger _codEmpresa;
@property(nonatomic)NSInteger _codUnidade;
@property(nonatomic,strong) NSString *_nomeFilial;
@property(nonatomic,strong) NSString *_enderecoFilial;
@property(nonatomic)NSInteger _codServico;
@property(nonatomic,strong) NSString *_servico;
@property(nonatomic) NSDate *_dataAgendamento;
@property(nonatomic,strong) NSString *_dataAgendamento1;
@property(nonatomic)NSInteger _codProfissional;
@property(nonatomic,strong) NSString *_profissional;
@property(nonatomic,strong) NSString *_horarioAgendamento;
@property(nonatomic)NSInteger _codAgendamento;
@property (assign, nonatomic) BOOL _withProfissional;
@property(nonatomic)NSInteger _statusAgendamento;

+(VariaveisGlobais*)shared;

@end
