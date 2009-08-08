#import <Foundation/Foundation.h>
#import "VSApplication.h"

int main (int argc, const char * argv[]) {
    NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
	
	VSApplication *app=[[VSApplication alloc] init];
	[app run];
	
    // insert code here...
    [pool drain];
    return 0;
}
