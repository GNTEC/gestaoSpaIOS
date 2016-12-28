//
//  VariaveisGlobais.m
//  AZB_ATEC
//
//  Created by ASTRAZENECA ISIT on 14/01/14.
//  Copyright (c) 2014 Marcelo Pavani. All rights reserved.
//

#import "VariaveisGlobais.h"

@implementation VariaveisGlobais

static VariaveisGlobais *instanciaCompartilhada = nil;

+(VariaveisGlobais*)shared
{
    if (instanciaCompartilhada == nil)
    {
        instanciaCompartilhada = [[self alloc] init];
    }
    
    return instanciaCompartilhada;
}

@end
