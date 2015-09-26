#include "OpenCVWrapper.h"
#import "UIImage+OpenCV.h"

#include <opencv2/opencv.hpp>

using namespace cv;
using namespace std;

@implementation OpenCVWrapper : NSObject

+ (UIImage *)processImageWithOpenCV:(UIImage*)inputImage {
    Mat mat = [inputImage CVMat];
    
    // do your processing here
    ...
    
    return [UIImage imageWithCVMat:mat];
}

@end