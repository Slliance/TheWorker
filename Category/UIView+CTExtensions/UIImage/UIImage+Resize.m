//
//  UIImage+Resize.m
//  DistributionProject
//
//  Created by liujianzhong on 15/7/20.
//  Copyright (c) 2015年 T.E.N_. All rights reserved.
//

#import "UIImage+Resize.h"
#import "UIImage+Alpha.h"
#import "UIImage+RoundedCorner.h"

@implementation UIImage (Resize)

// Returns a copy of this image that is cropped to the given bounds.
// The bounds will be adjusted using CGRectIntegral.
// This method ignores the image's imageOrientation setting.
- (UIImage *)croppedImage:(CGRect)bounds {
    CGImageRef imageRef = CGImageCreateWithImageInRect([self CGImage], bounds);
    UIImage *croppedImage = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    return croppedImage;
}

// Returns a copy of this image that is squared to the thumbnail size.
// If transparentBorder is non-zero, a transparent border of the given size will be added around the edges of the thumbnail. (Adding a transparent border of at least one pixel in size has the side-effect of antialiasing the edges of the image when rotating it using Core Animation.)
- (UIImage *)thumbnailImage:(NSInteger)thumbnailSize
          transparentBorder:(NSUInteger)borderSize
               cornerRadius:(NSUInteger)cornerRadius
       interpolationQuality:(CGInterpolationQuality)quality {
    UIImage *resizedImage = [self resizedImageWithContentMode:UIViewContentModeScaleAspectFill
                                                       bounds:CGSizeMake(thumbnailSize, thumbnailSize)
                                         interpolationQuality:quality];
    
    // Crop out any part of the image that's larger than the thumbnail size
    // The cropped rect must be centered on the resized image
    // Round the origin points so that the size isn't altered when CGRectIntegral is later invoked
    CGRect cropRect = CGRectMake(round((resizedImage.size.width - thumbnailSize) / 2),
                                 round((resizedImage.size.height - thumbnailSize) / 2),
                                 thumbnailSize,
                                 thumbnailSize);
    UIImage *croppedImage = [resizedImage croppedImage:cropRect];
    
    UIImage *transparentBorderImage = borderSize ? [croppedImage transparentBorderImage:borderSize] : croppedImage;
    
    return [transparentBorderImage roundedCornerImage:cornerRadius borderSize:borderSize];
}

// Returns a rescaled copy of the image, taking into account its orientation
// The image will be scaled disproportionately if necessary to fit the bounds specified by the parameter
- (UIImage *)resizedImage:(CGSize)newSize interpolationQuality:(CGInterpolationQuality)quality {
    BOOL drawTransposed;
    
    switch (self.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            drawTransposed = YES;
            break;
            
        default:
            drawTransposed = NO;
    }
    
    return [self resizedImage:newSize
                    transform:[self transformForOrientation:newSize]
               drawTransposed:drawTransposed
         interpolationQuality:quality];
}

// Resizes the image according to the given content mode, taking into account the image's orientation
- (UIImage *)resizedImageWithContentMode:(UIViewContentMode)contentMode
                                  bounds:(CGSize)bounds
                    interpolationQuality:(CGInterpolationQuality)quality {
    
    
    CGFloat horizontalRatio = bounds.width / self.size.width;
    CGFloat verticalRatio = bounds.height / self.size.height;
    CGFloat ratio;
    
    switch (contentMode) {
        case UIViewContentModeScaleAspectFill:
            ratio = MAX(horizontalRatio, verticalRatio);
            break;
            
        case UIViewContentModeScaleAspectFit:
            ratio = MIN(horizontalRatio, verticalRatio);
            break;
            
        default:
            [NSException raise:NSInvalidArgumentException format:@"Unsupported content mode: %ld", (long)contentMode];
    }
    
    CGSize newSize = CGSizeMake(self.size.width * ratio, self.size.height * ratio);
    
    if (bounds.width <= 50 || bounds.height <= 50 ) {
        return [self resizedImage:newSize interpolationQuality:quality];
    }
    
    NSData *data=UIImageJPEGRepresentation(self, 1.0);
    if (data.length < 512 * 1024) {
        return self;
    }else{
        return [self resizedImage:newSize interpolationQuality:quality];
    }
}

#pragma mark -
#pragma mark Private helper methods

// Returns a copy of the image that has been transformed using the given affine transform and scaled to the new size
// The new image's orientation will be UIImageOrientationUp, regardless of the current image's orientation
// If the new size is not integral, it will be rounded up
- (UIImage *)resizedImage:(CGSize)newSize
                transform:(CGAffineTransform)transform
           drawTransposed:(BOOL)transpose
     interpolationQuality:(CGInterpolationQuality)quality {
    
    CGRect newRect = CGRectIntegral(CGRectMake(0, 0, newSize.width, newSize.height));
    CGRect transposedRect = CGRectMake(0, 0, newRect.size.height, newRect.size.width);
    CGImageRef imageRef = self.CGImage;
    
    CGColorSpaceRef colorspace = CGColorSpaceCreateDeviceRGB();
    // Build a context that's the same dimensions as the new size
    CGContextRef bitmap =  CGBitmapContextCreate(NULL,
                                                 newRect.size.width,        /* size_t width */
                                                 newRect.size.height,       /* size_t height */
                                                 8,      /* bits per component 32/4 */
                                                 newRect.size.width * 4,  /* bytes per row 每行字节数,每一个位图像素的代表是4个字节 */
                                                 colorspace,            /* cgcolorspaceref */
                                                 kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
    
    // Rotate and/or flip the image if required by its orientation
    CGContextConcatCTM(bitmap, transform);
    // Set the quality level to use when rescaling
    CGContextSetInterpolationQuality(bitmap, quality);
    // Draw into the context; this scales the image
    CGContextDrawImage(bitmap, transpose ? transposedRect : newRect, imageRef);
    // Get the resized image from the context and a UIImage
    CGImageRef newImageRef = CGBitmapContextCreateImage(bitmap);
    UIImage *newImage = [UIImage imageWithCGImage:newImageRef];
    // Clean up
    CGContextRelease(bitmap);
    CGImageRelease(newImageRef);
    return [self imageWithImage:newImage scaledToSize:newSize];
//    return newImage;
}

- (UIImage *)imageWithImage:(UIImage*)image  scaledToSize:(CGSize)newSize;
{
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    NSData *imageData = [UIImage imageData:newImage];
    UIImage *imageResult = [UIImage imageWithData:imageData];
    //    UIImageWriteToSavedPhotosAlbum(imageResult, nil, nil, nil);
    return imageResult;
    
}

+(NSData *)imageData:(UIImage *)myimage{
    NSData *data=UIImageJPEGRepresentation(myimage, 1.0);
    if (data.length>200*1024) {
        if (data.length>1024*1024) {//1M以及以上
            data=UIImageJPEGRepresentation(myimage, 0.1);
        }else if (data.length>512*1024) {//0.5M-1M
            data=UIImageJPEGRepresentation(myimage, 0.5);
        }else if (data.length>200*1024) {//0.25M-0.5M
            data=UIImageJPEGRepresentation(myimage, 0.9);
        }
    } else {
        return data;
    }
    return data;
}
    
// Returns an affine transform that takes into account the image orientation when drawing a scaled image
- (CGAffineTransform)transformForOrientation:(CGSize)newSize {
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    switch (self.imageOrientation) {
        case UIImageOrientationDown:           // EXIF = 3
        case UIImageOrientationDownMirrored:   // EXIF = 4
            transform = CGAffineTransformTranslate(transform, newSize.width, newSize.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:           // EXIF = 6
        case UIImageOrientationLeftMirrored:   // EXIF = 5
            transform = CGAffineTransformTranslate(transform, newSize.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:          // EXIF = 8
        case UIImageOrientationRightMirrored:  // EXIF = 7
            transform = CGAffineTransformTranslate(transform, 0, newSize.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        default:
            break;
    }
    
    
    switch (self.imageOrientation) {
        case UIImageOrientationUpMirrored:     // EXIF = 2
        case UIImageOrientationDownMirrored:   // EXIF = 4
            transform = CGAffineTransformTranslate(transform, newSize.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:   // EXIF = 5
        case UIImageOrientationRightMirrored:  // EXIF = 7
            transform = CGAffineTransformTranslate(transform, newSize.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        default:
            break;
    }
    
    return transform;
}

@end
