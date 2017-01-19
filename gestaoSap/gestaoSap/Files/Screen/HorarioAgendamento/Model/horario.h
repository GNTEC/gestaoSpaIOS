//
//  horario.h
//  gestaoSap
//
//  Created by User on 19/01/17.
//  Copyright © 2017 gntec. All rights reserved.
//

#import <Foundation/Foundation.h>

//{"COD_PROFISSIONAL":3677,"DT_INI":"20/01/2016 08:00:00","DT_FIM":"01/01/0001 00:00:00"}

@interface horario : NSObject
{
    NSInteger codProfissional;
    NSString *dataIni;
    NSString *dataFim;
}

@property(nonatomic) NSInteger codProfissional;
@property(nonatomic,retain) NSString *dataIni;
@property(nonatomic,retain) NSString *dataFim;

@end
