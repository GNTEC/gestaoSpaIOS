//
//  unidade.h
//  gestaoSap
//
//  Created by User on 11/01/17.
//  Copyright © 2017 gntec. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface unidade : NSObject
{
    int codFilal;
    NSString *nomeFilial;
    NSString *enderecoFilial;
}

@property(nonatomic) NSInteger codFilal;
@property(nonatomic,retain) NSString *nomeFilial;
@property(nonatomic,retain) NSString *enderecoFilial;

@end
