//
//  DefaultPacketEncrypter.h
//  SFS2X
//
//  Created by Lapo on 01/06/15.
//

#import <Foundation/Foundation.h>
#import "BitSwarmClient.h"

@interface DefaultPacketEncrypter : NSObject
{
    BitSwarmClient* _bitSwarm;
}

-(id) initWithBitSwarm:(BitSwarmClient*)bsc;

-(NSData*) encode:(NSData*)data;
-(NSData*) decode:(NSData*)data;

@end
