# Dynamic image color 2

This is another example of how to change the color of an image dynamically. This example uses the [Core Image filter Color Cross Polynomial](https://developer.apple.com/library/ios/documentation/GraphicsImaging/Reference/CoreImageFilterReference/index.html#//apple_ref/doc/filter/ci/CIColorCrossPolynomial)

This version of Dynamic image color has more freedom among the color spectrum.

# Some considerations
- Rendering an image can take a while, so make sure you render images asynchronously as I have done so in this example
- The larger the image, the more resource expensive applying the filters will be. Keep this in mind when designing your application.

# References
- [Core Image Programming Guide](https://developer.apple.com/library/ios/documentation/GraphicsImaging/Conceptual/CoreImaging/ci_intro/ci_intro.html)
- [Drawing and Printing Guide for iOS](https://developer.apple.com/library/ios/documentation/2DDrawing/Conceptual/DrawingPrintingiOS/GraphicsDrawingOverview/GraphicsDrawingOverview.html)
- [Quartz 2D Programming Guide](https://developer.apple.com/library/ios/documentation/GraphicsImaging/Conceptual/drawingwithquartz2d/Introduction/Introduction.html)
