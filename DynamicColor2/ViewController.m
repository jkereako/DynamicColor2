//
//  ViewController.m
//  DynamicColor2
//
//  Created by Jeffrey Kereakoglow on 2/17/15.
//  Copyright (c) 2015 Alexis Digital. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

/**
 @brief Create the context once. It's thread-safe and is expensive to build.
 @see https://developer.apple.com/library/ios/documentation/GraphicsImaging/Conceptual/CoreImaging/ci_performance/ci_performance.html#//apple_ref/doc/uid/TP30001185-CH10-SW2
 */
@property (nonatomic, readonly) CIContext *context;
/**
 @brief Create the input image once. It's thread-safe.
 */
@property (nonatomic, readonly) CIImage *inputImage;
@property (nonatomic) CGFloat redValue;
@property (nonatomic) CGFloat greenValue;
@property (nonatomic) CGFloat blueValue;

@property (nonatomic, weak) IBOutlet UIImageView *imageView;

- (IBAction)redSliderChangedAction:(UISlider *)sender;
- (IBAction)greenSliderChangedAction:(UISlider *)sender;
- (IBAction)blueSliderChangedAction:(UISlider *)sender;

- (void)updateColorWithRedValue:(CGFloat)redValue greenValue:(CGFloat)greenValue blueValue:(CGFloat)blueValue;

@end

@implementation ViewController


// Create instance variables to store values without creating setters.
@synthesize context = _context;
@synthesize inputImage = _inputImage;

#pragma mark - Getters
- (CIContext *)context {
    if (_context) {
        return _context;
    }

    // Instantiate the context without color management for better performance.
    // @see: https://developer.apple.com/library/ios/documentation/GraphicsImaging/Conceptual/CoreImaging/ci_performance/ci_performance.html#//apple_ref/doc/uid/TP30001185-CH10-SW7
    _context = [CIContext contextWithOptions:@{kCIImageColorSpace:[NSNull null]}];

    return _context;
}

- (CIImage *)inputImage {
    if (_inputImage) {
        return _inputImage;
    }

    // Create the input image only once because this object is immutable
    _inputImage = [CIImage imageWithCGImage:self.imageView.image.CGImage];

    return _inputImage;
}

#pragma mark - Actions
- (IBAction)redSliderChangedAction:(UISlider *)sender {
    self.redValue = sender.value;

    [self updateColorWithRedValue:self.redValue
                       greenValue:self.greenValue
                        blueValue:self.blueValue];
}

- (IBAction)greenSliderChangedAction:(UISlider *)sender {
    self.greenValue = sender.value;

    [self updateColorWithRedValue:self.redValue
                       greenValue:self.greenValue
                        blueValue:self.blueValue];
}

- (IBAction)blueSliderChangedAction:(UISlider *)sender {
    self.blueValue = sender.value;

    [self updateColorWithRedValue:self.redValue
                       greenValue:self.greenValue
                        blueValue:self.blueValue];
}

- (void)updateColorWithRedValue:(CGFloat)redValue greenValue:(CGFloat)greenValue blueValue:(CGFloat)blueValue {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),
                   ^(void) {
                       // CIFilters are mutable and as such they are not thread-safe. Make sure
                       // each thread maintains its own CIFilter object.
                       CIFilter *filter = [CIFilter filterWithName:@"CIColorCrossPolynomial"
                                                     keysAndValues:
                                           kCIInputImageKey, self.inputImage,
                                           @"inputRedCoefficients", [CIVector vectorWithX:redValue],
                                           @"inputGreenCoefficients", [CIVector vectorWithX:greenValue],
                                           @"inputBlueCoefficients", [CIVector vectorWithX:blueValue],
                                           nil];

                       // The image has not yet been rendered. The CIImage* object contains
                       // instructions for how to render the image.
                       CIImage *image = [filter valueForKey:kCIOutputImageKey];

                       // Now, the image has been rendered. This process can take a while so we
                       // have ought to run it asynchronously.
                       CGImageRef __block imageRef = [self.context createCGImage:image
                                                                        fromRect:image.extent];

                       dispatch_async(dispatch_get_main_queue(), ^(void) {
                           self.imageView.image = [UIImage imageWithCGImage:imageRef];

                           // Release the object otherwise you'll end up with a huge leak.
                           CGImageRelease(imageRef);
                       });
                   });
}

@end
