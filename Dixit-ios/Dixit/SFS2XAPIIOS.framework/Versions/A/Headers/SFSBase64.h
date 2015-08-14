//
//  SFSBase64.h
//  SFS2X
//
//  Created by Lapo on 29/05/15.
//  Copyright (c) 2015 A51 Integrated | http://a51integrated.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SFSBase64 : NSObject

+(NSString*) encode:(NSData*)data;
+(NSData*) decode:(NSString*)data;

@end
