function ang=pix2angle(display,n)%PIX2ANGLE%ang=pix2angle(display,n)ang=2*180*atan(display.pixelSize*(n/2)/display.distance)/pi;