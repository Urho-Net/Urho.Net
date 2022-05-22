#if defined(IOS) || defined(TVOS)

#include "ios_support.h"
#include <mono/jit/jit.h>
#include <mono/metadata/environment.h>
#include <mono/utils/mono-publib.h>
#include <mono/metadata/mono-config.h>
#include <mono/metadata/assembly.h>
#import <Foundation/Foundation.h>
#include <os/log.h>
#include <sys/stat.h>
#include <sys/mman.h>

#define GD_PINVOKE_EXPORT extern "C" __attribute__((visibility("default")))

GD_PINVOKE_EXPORT int32_t SystemIoPortsNative_TermiosGetSignal(intptr_t fd, int32_t signal)
{
    return -1;
}

GD_PINVOKE_EXPORT int32_t SystemIoPortsNative_TermiosSetSignal(intptr_t fd, int32_t signal, int32_t set)
{
    return -1;
}

GD_PINVOKE_EXPORT int32_t SystemIoPortsNative_TermiosGetAllSignals(intptr_t fd)
{
    return -1;
}

GD_PINVOKE_EXPORT int32_t SystemIoPortsNative_TermiosGetSpeed(intptr_t fd)
{
    return -1;
}

GD_PINVOKE_EXPORT int32_t SystemIoPortsNative_TermiosSetSpeed(intptr_t fd, int32_t speed)
{
    return -1;
}

GD_PINVOKE_EXPORT int32_t SystemIoPortsNative_TermiosAvailableBytes(intptr_t fd, int32_t readBuffer)
{
    return -1;
}

GD_PINVOKE_EXPORT int32_t SystemIoPortsNative_TermiosReset(intptr_t fd, int32_t speed, int32_t dataBits, int32_t stopBits, int32_t parity, int32_t handshake)
{
    return -1;
}

GD_PINVOKE_EXPORT int32_t SystemIoPortsNative_TermiosDiscard(intptr_t fd, int32_t queue)
{
    return -1;
}

GD_PINVOKE_EXPORT int32_t SystemIoPortsNative_TermiosDrain(intptr_t fd)
{
    return -1;
}

GD_PINVOKE_EXPORT int32_t SystemIoPortsNative_TermiosSendBreak(intptr_t fd, int32_t duration)
{
    return -1;
}

GD_PINVOKE_EXPORT intptr_t SystemIoPortsNative_SerialPortOpen(const char *name)
{
    return NULL;
}

GD_PINVOKE_EXPORT int SystemIoPortsNative_SerialPortClose(intptr_t fd)
{
    return -1;
}

GD_PINVOKE_EXPORT int32_t SystemIoPortsNative_Read(intptr_t fd, void *buffer, int32_t bufferSize)
{
    return -1;
}

GD_PINVOKE_EXPORT int32_t SystemIoPortsNative_Write(intptr_t fd, const void *buffer, int32_t bufferSize)
{
    return -1;
}

GD_PINVOKE_EXPORT int32_t SystemIoPortsNative_Poll(void *pollEvents, uint32_t eventCount, int32_t milliseconds, uint32_t *triggered)
{
    return -1;
}

GD_PINVOKE_EXPORT int32_t SystemIoPortsNative_Shutdown(intptr_t socket, int32_t socketShutdown)
{
    return -1;
}

GD_PINVOKE_EXPORT int32_t SystemIoPortsNative_ConvertErrorPlatformToPal(int32_t platformErrno)
{
    return -1;
}

GD_PINVOKE_EXPORT int32_t SystemIoPortsNative_ConvertErrorPalToPlatform(int32_t error)
{
    return -1;
}

GD_PINVOKE_EXPORT const char *SystemIoPortsNative_StrErrorR(int32_t platformErrno, char *buffer, int32_t bufferSize)
{
    return NULL;
}

GD_PINVOKE_EXPORT void *XOpenDisplay(void *display)
{
    return NULL;
}

GD_PINVOKE_EXPORT int XCloseDisplay(void *display)
{
    return -1;
}

GD_PINVOKE_EXPORT void *XRootWindow(void *display, int screen)
{
    return NULL;
}

GD_PINVOKE_EXPORT int XDefaultScreen(void *display)
{
    return -1;
}

GD_PINVOKE_EXPORT uint XDefaultDepth(void *display, int screen)
{
    return 1;
}

GD_PINVOKE_EXPORT void *XGetImage(void *display, void *drawable, int src_x, int src_y, int width, int height, int pane, int format)
{
    return NULL;
}

GD_PINVOKE_EXPORT int XGetPixel(void *image, int x, int y) { return -1; }

GD_PINVOKE_EXPORT int XDestroyImage(void *image) { return -1; }

GD_PINVOKE_EXPORT void *XDefaultVisual(void *display, int screen) { return NULL; }

GD_PINVOKE_EXPORT void *XGetVisualInfo(void *display, int vinfo_mask, void *vinfo_template, int *nitems) { return NULL; }

GD_PINVOKE_EXPORT void *XVisualIDFromVisual(void *visual) { return NULL; }

GD_PINVOKE_EXPORT void XFree(void *data) {}

GD_PINVOKE_EXPORT int cupsGetDests(void *dests) { return -1; }

GD_PINVOKE_EXPORT void cupsFreeDests(int num_dests, void *dests) {}

GD_PINVOKE_EXPORT void *cupsTempFd(void *sb, int len) { return NULL; }

GD_PINVOKE_EXPORT void *cupsGetDefault() { return NULL; }

GD_PINVOKE_EXPORT int cupsPrintFile(char *printer, char *filename, char *title, int num_options, void *options) { return -1; }

GD_PINVOKE_EXPORT void *cupsGetPPD(char *printer) { return NULL; }

GD_PINVOKE_EXPORT void *ppdOpenFile(char *filename) { return NULL; }

GD_PINVOKE_EXPORT void *ppdFindOption(void *ppd_file, char *keyword) { return NULL; }

GD_PINVOKE_EXPORT void ppdClose(void *ppd) {}

GD_PINVOKE_EXPORT int cupsParseOptions(char *arg, int number_of_options, void *options) { return -1; }

GD_PINVOKE_EXPORT void cupsFreeOptions(int number_options, void *options) {}

GD_PINVOKE_EXPORT void *CGMainDisplayID() { return NULL; }

GD_PINVOKE_EXPORT void *CGDisplayBounds(void *display) { return NULL; }

GD_PINVOKE_EXPORT int HIViewGetBounds(void *vHnd, void *r) { return -1; }

GD_PINVOKE_EXPORT int HIViewConvertRect(void *r, void *a, void *b) { return -1; }

GD_PINVOKE_EXPORT void *GetControlOwner(void *aView) { return NULL; }

GD_PINVOKE_EXPORT int GetWindowBounds(void *wHnd, uint reg, void *rect) { return -1; }

GD_PINVOKE_EXPORT void *GetWindowPort(void *hWnd) { return NULL; }

GD_PINVOKE_EXPORT void *GetQDGlobalsThePort() { return NULL; }

GD_PINVOKE_EXPORT void CreateCGContextForPort(void *port, void *context) {}

GD_PINVOKE_EXPORT void QDBeginCGContext(void *port, void *context) {}

GD_PINVOKE_EXPORT void QDEndCGContext(void *port, void *context) {}

GD_PINVOKE_EXPORT int CGContextClipToRect(void *context, int clip) { return -1; }

GD_PINVOKE_EXPORT int CGContextClipToRects(void *context, void *clip_rects, int count) { return -1; }

GD_PINVOKE_EXPORT void CGContextTranslateCTM(void *context, float tx, float ty) {}

GD_PINVOKE_EXPORT void CGContextScaleCTM(void *context, float x, float y) {}

GD_PINVOKE_EXPORT void CGContextFlush(void *context) {}

GD_PINVOKE_EXPORT void CGContextSynchronize(void *context) {}

GD_PINVOKE_EXPORT void *CGPathCreateMutable() { return NULL; }

GD_PINVOKE_EXPORT void CGPathAddRects(void *path, void *_void, void *rects, int count) {}

GD_PINVOKE_EXPORT void CGPathAddRect(void *path, void *_void, void *rect) {}

GD_PINVOKE_EXPORT void CGContextAddRects(void *context, void *rects, int count) {}

GD_PINVOKE_EXPORT void CGContextAddRect(void *context, void *rect) {}

GD_PINVOKE_EXPORT void CGContextBeginPath(void *context) {}

GD_PINVOKE_EXPORT void CGContextClosePath(void *context) {}

GD_PINVOKE_EXPORT void CGContextAddPath(void *context, void *path) {}

GD_PINVOKE_EXPORT void CGContextClip(void *context) {}

GD_PINVOKE_EXPORT void CGContextEOClip(void *context) {}

GD_PINVOKE_EXPORT void CGContextEOFillPath(void *context) {}

GD_PINVOKE_EXPORT void CGContextSaveGState(void *context) {}

GD_PINVOKE_EXPORT void CGContextRestoreGState(void *context) {}


#endif // IPHONE_ENABLED