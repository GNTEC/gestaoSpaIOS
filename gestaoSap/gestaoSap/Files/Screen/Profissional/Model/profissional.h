//
//  profissional.h
//  gestaoSap
//
//  Created by User on 19/01/17.
//  Copyright © 2017 gntec. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface profissional : NSObject
{
    NSInteger codProfissional;
    NSString *nomeProfissional;
}

@property(nonatomic) NSInteger codProfissional;
@property(nonatomic,retain) NSString *nomeProfissional;

@end
