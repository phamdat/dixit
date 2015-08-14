//
//  SFSCryptoInitializer.h
//  SFS2X
//
//  Created by Lapo on 29/05/15.
//  Copyright (c) 2015 A51 Integrated | http://a51integrated.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SmartFox2XClient.h"

@interface SFSCryptoInitializer : NSObject
{
    SmartFox2XClient* _sfs;
}

-(id)initWithSFS:(SmartFox2XClient *)sfs;
-(void) execute;

@end
