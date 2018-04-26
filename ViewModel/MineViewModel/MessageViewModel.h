//
//  MessageViewModel.h
//  jishikangUser
//
//  Created by yanghao on 7/14/17.
//  Copyright © 2017 huying. All rights reserved.
//

#import "BaseViewModel.h"

@interface MessageViewModel : BaseViewModel

-(void)fetchMsg:(NSInteger)page token:(NSString *)token;


-(void)delMessageWithId:(NSString *)Id token:(NSString *)token;

    
    
@end
