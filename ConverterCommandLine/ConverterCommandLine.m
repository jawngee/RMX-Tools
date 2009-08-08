#import <Foundation/Foundation.h>
#import "ApplicationMain.h"

int main (int argc, const char * argv[]) {
    NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];

	ApplicationMain *appmain=[[ApplicationMain alloc] init];
	[appmain run];
	
    [pool drain];
    return 0;
}
