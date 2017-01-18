//
//  servico.h
//  gestaoSap
//
//  Created by User on 18/01/17.
//  Copyright © 2017 gntec. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface servico : NSObject
{
    NSInteger codServico;
    NSString *descricaoServico;
    NSString *valor;
}

@property(nonatomic) NSInteger codServico;
@property(nonatomic,retain) NSString *descricaoServico;
@property(nonatomic,retain) NSString *valor;

@end
