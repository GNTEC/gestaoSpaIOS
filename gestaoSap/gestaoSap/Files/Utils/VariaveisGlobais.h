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
}

//variavel que vai controlar se devemos pedir mais tempo para tarefa em background ou não
@property(nonatomic)NSInteger _codCliente;
@property(nonatomic)NSInteger _codEmpresa;
@property(nonatomic)NSInteger _codUnidade;

+(VariaveisGlobais*)shared;

@end
