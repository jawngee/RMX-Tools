#import <Foundation/Foundation.h>
#import "SDApplication.h"

int main (int argc, const char * argv[]) 
{
    NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];

	SDApplication *app=[[[SDApplication alloc] init] autorelease];
	[app run];

    [pool drain];
    return 0;
}
