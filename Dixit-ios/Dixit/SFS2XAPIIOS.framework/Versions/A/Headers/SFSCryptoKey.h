//
//  CryptoKey.h
//  SFS2X
//
//  Created by Lapo on 01/06/15.
//  Copyright (c) 2015 A51 Integrated | http://a51integrated.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SFSCryptoKey : NSObject

@property (nonatomic) NSData* iv;
@property (nonatomic) NSData* key;

@end
