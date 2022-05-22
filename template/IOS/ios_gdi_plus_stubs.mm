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

GD_PINVOKE_EXPORT int GdipBeginContainer(void *graphics, void *dstRect, void *srcRect, int unit, void *state)
{
    return 1;
}

GD_PINVOKE_EXPORT int GdipBeginContainer2(void *graphics, void *state)
{
    return 1;
}

GD_PINVOKE_EXPORT int GdipBeginContainerI(void *graphics, void *dstRect, void *srcRect, int unit, void *state) { return 1; }

GD_PINVOKE_EXPORT int GdipEndContainer(void *graphics, int state) { return 1; }

GD_PINVOKE_EXPORT int GdipCreateAdjustableArrowCap(float height, float width, bool isFilled, void *adjustableArrowCap) { return 1; }

GD_PINVOKE_EXPORT int GdipGetAdjustableArrowCapHeight(void *adjustableArrowCap, void *height) { return 1; }

GD_PINVOKE_EXPORT int GdipSetAdjustableArrowCapHeight(void *adjustableArrowCap, float height) { return 1; }

GD_PINVOKE_EXPORT int GdipSetAdjustableArrowCapWidth(void *adjustableArrowCap, float width) { return 1; }

GD_PINVOKE_EXPORT int GdipGetAdjustableArrowCapWidth(void *adjustableArrowCap, void *width) { return 1; }

GD_PINVOKE_EXPORT int GdipSetAdjustableArrowCapMiddleInset(void *adjustableArrowCap, float middleInset) { return 1; }

GD_PINVOKE_EXPORT int GdipGetAdjustableArrowCapMiddleInset(void *adjustableArrowCap, void *middleInset) { return 1; }

GD_PINVOKE_EXPORT int GdipSetAdjustableArrowCapFillState(void *adjustableArrowCap, bool fillState) { return 1; }

GD_PINVOKE_EXPORT int GdipGetAdjustableArrowCapFillState(void *adjustableArrowCap, void *fillState) { return 1; }

GD_PINVOKE_EXPORT int GdipGetCustomLineCapType(void *customCap, void *capType) { return 1; }

GD_PINVOKE_EXPORT int GdipCreateCustomLineCap(void *fillpath, void *strokepath, int baseCap, float baseInset, void *customCap) { return 1; }

GD_PINVOKE_EXPORT int GdipDeleteCustomLineCap(void *customCap) { return 1; }

// GD_PINVOKE_EXPORT int GdipDeleteCustomLineCap(void * customCap){ return 1; }

GD_PINVOKE_EXPORT int GdipCloneCustomLineCap(void *customCap, void *clonedCap) { return 1; }

GD_PINVOKE_EXPORT int GdipSetCustomLineCapStrokeCaps(void *customCap, int startCap, int endCap) { return 1; }

GD_PINVOKE_EXPORT int GdipGetCustomLineCapStrokeCaps(void *customCap, void *startCap, void *endCap) { return 1; }

GD_PINVOKE_EXPORT int GdipSetCustomLineCapStrokeJoin(void *customCap, int lineJoin) { return 1; }

GD_PINVOKE_EXPORT int GdipGetCustomLineCapStrokeJoin(void *customCap, void *lineJoin) { return 1; }

GD_PINVOKE_EXPORT int GdipSetCustomLineCapBaseCap(void *customCap, int baseCap) { return 1; }

GD_PINVOKE_EXPORT int GdipGetCustomLineCapBaseCap(void *customCap, void *baseCap) { return 1; }

GD_PINVOKE_EXPORT int GdipSetCustomLineCapBaseInset(void *customCap, float inset) { return 1; }

GD_PINVOKE_EXPORT int GdipGetCustomLineCapBaseInset(void *customCap, void *inset) { return 1; }

GD_PINVOKE_EXPORT int GdipSetCustomLineCapWidthScale(void *customCap, float widthScale) { return 1; }

GD_PINVOKE_EXPORT int GdipGetCustomLineCapWidthScale(void *customCap, void *widthScale) { return 1; }

GD_PINVOKE_EXPORT int GdipCreatePathIter(void *pathIter, void *path) { return 1; }

GD_PINVOKE_EXPORT int GdipDeletePathIter(void *pathIter) { return 1; }

GD_PINVOKE_EXPORT int GdipPathIterNextSubpath(void *pathIter, void *resultCount, void *startIndex, void *endIndex, void *isClosed) { return 1; }

GD_PINVOKE_EXPORT int GdipPathIterNextSubpathPath(void *pathIter, void *resultCount, void *path, void *isClosed) { return 1; }

GD_PINVOKE_EXPORT int GdipPathIterNextPathType(void *pathIter, void *resultCount, void *pathType, void *startIndex, void *endIndex) { return 1; }

GD_PINVOKE_EXPORT int GdipPathIterNextMarker(void *pathIter, void *resultCount, void *startIndex, void *endIndex) { return 1; }

GD_PINVOKE_EXPORT int GdipPathIterNextMarkerPath(void *pathIter, void *resultCount, void *path) { return 1; }

GD_PINVOKE_EXPORT int GdipPathIterGetCount(void *pathIter, void *count) { return 1; }

GD_PINVOKE_EXPORT int GdipPathIterGetSubpathCount(void *pathIter, void *count) { return 1; }

GD_PINVOKE_EXPORT int GdipPathIterHasCurve(void *pathIter, void *hasCurve) { return 1; }

GD_PINVOKE_EXPORT int GdipPathIterRewind(void *pathIter) { return 1; }

GD_PINVOKE_EXPORT int GdipPathIterEnumerate(void *pathIter, void *resultCount, void *points, void *types, int count) { return 1; }

GD_PINVOKE_EXPORT int GdipPathIterCopyData(void *pathIter, void *resultCount, void *points, void *types, int startIndex, int endIndex) { return 1; }

GD_PINVOKE_EXPORT int GdipCreateHatchBrush(int hatchstyle, int forecol, int backcol, void *brush) { return 1; }

GD_PINVOKE_EXPORT int GdipGetHatchStyle(void *brush, void *hatchstyle) { return 1; }

GD_PINVOKE_EXPORT int GdipGetHatchForegroundColor(void *brush, void *forecol) { return 1; }

GD_PINVOKE_EXPORT int GdipGetHatchBackgroundColor(void *brush, void *backcol) { return 1; }

GD_PINVOKE_EXPORT int GdipCloneBrush(void *brush, void *clonebrush) { return 1; }

GD_PINVOKE_EXPORT int GdipCreateLineBrush(void *point1, void *point2, int color1, int color2, int wrapMode, void *lineGradient) { return 1; }

GD_PINVOKE_EXPORT int GdipCreateLineBrushI(void *point1, void *point2, int color1, int color2, int wrapMode, void *lineGradient) { return 1; }

GD_PINVOKE_EXPORT int GdipCreateLineBrushFromRect(void *rect, int color1, int color2, int lineGradientMode, int wrapMode, void *lineGradient) { return 1; }

GD_PINVOKE_EXPORT int GdipCreateLineBrushFromRectI(void *rect, int color1, int color2, int lineGradientMode, int wrapMode, void *lineGradient) { return 1; }

GD_PINVOKE_EXPORT int GdipCreateLineBrushFromRectWithAngle(void *rect, int color1, int color2, float angle, bool isAngleScaleable, int wrapMode, void *lineGradient) { return 1; }

GD_PINVOKE_EXPORT int GdipCreateLineBrushFromRectWithAngleI(void *rect, int color1, int color2, float angle, bool isAngleScaleable, int wrapMode, void *lineGradient) { return 1; }

GD_PINVOKE_EXPORT int GdipSetLineColors(void *brush, int color1, int color2) { return 1; }

GD_PINVOKE_EXPORT int GdipGetLineColors(void *brush, int *colors) { return 1; }

GD_PINVOKE_EXPORT int GdipGetLineRect(void *brush, void *gprectf) { return 1; }

GD_PINVOKE_EXPORT int GdipGetLineGammaCorrection(void *brush, void *useGammaCorrection) { return 1; }

GD_PINVOKE_EXPORT int GdipSetLineGammaCorrection(void *brush, bool useGammaCorrection) { return 1; }

GD_PINVOKE_EXPORT int GdipSetLineSigmaBlend(void *brush, float focus, float scale) { return 1; }

GD_PINVOKE_EXPORT int GdipSetLineLinearBlend(void *brush, float focus, float scale) { return 1; }

GD_PINVOKE_EXPORT int GdipGetLineBlendCount(void *brush, void *count) { return 1; }

GD_PINVOKE_EXPORT int GdipGetLineBlend(void *brush, void *blend, void *positions, int count) { return 1; }

GD_PINVOKE_EXPORT int GdipSetLineBlend(void *brush, void *blend, void *positions, int count) { return 1; }

GD_PINVOKE_EXPORT int GdipGetLinePresetBlendCount(void *brush, void *count) { return 1; }

GD_PINVOKE_EXPORT int GdipGetLinePresetBlend(void *brush, void *blend, void *positions, int count) { return 1; }

GD_PINVOKE_EXPORT int GdipSetLinePresetBlend(void *brush, void *blend, void *positions, int count) { return 1; }

GD_PINVOKE_EXPORT int GdipSetLineWrapMode(void *brush, int wrapMode) { return 1; }

GD_PINVOKE_EXPORT int GdipGetLineWrapMode(void *brush, void *wrapMode) { return 1; }

GD_PINVOKE_EXPORT int GdipResetLineTransform(void *brush) { return 1; }

GD_PINVOKE_EXPORT int GdipMultiplyLineTransform(void *brush, void *matrix, int order) { return 1; }

GD_PINVOKE_EXPORT int GdipGetLineTransform(void *brush, void *matrix) { return 1; }

GD_PINVOKE_EXPORT int GdipSetLineTransform(void *brush, void *matrix) { return 1; }

GD_PINVOKE_EXPORT int GdipTranslateLineTransform(void *brush, float dx, float dy, int order) { return 1; }

GD_PINVOKE_EXPORT int GdipScaleLineTransform(void *brush, float sx, float sy, int order) { return 1; }

GD_PINVOKE_EXPORT int GdipRotateLineTransform(void *brush, float angle, int order) { return 1; }

GD_PINVOKE_EXPORT int GdipCreatePathGradient(void *points, int count, int wrapMode, void *brush) { return 1; }

GD_PINVOKE_EXPORT int GdipCreatePathGradientI(void *points, int count, int wrapMode, void *brush) { return 1; }

GD_PINVOKE_EXPORT int GdipCreatePathGradientFromPath(void *path, void *brush) { return 1; }

GD_PINVOKE_EXPORT int GdipGetPathGradientCenterColor(void *brush, void *color) { return 1; }

GD_PINVOKE_EXPORT int GdipSetPathGradientCenterColor(void *brush, int color) { return 1; }

GD_PINVOKE_EXPORT int GdipGetPathGradientSurroundColorsWithCount(void *brush, int *color, int *count) { return 1; }

GD_PINVOKE_EXPORT int GdipSetPathGradientSurroundColorsWithCount(void *brush, int *argb, int *count) { return 1; }

GD_PINVOKE_EXPORT int GdipGetPathGradientCenterPoint(void *brush, void *point) { return 1; }

GD_PINVOKE_EXPORT int GdipSetPathGradientCenterPoint(void *brush, void *point) { return 1; }

GD_PINVOKE_EXPORT int GdipGetPathGradientRect(void *brush, void *gprectf) { return 1; }

GD_PINVOKE_EXPORT int GdipGetPathGradientPointCount(void *brush, void *count) { return 1; }

GD_PINVOKE_EXPORT int GdipGetPathGradientSurroundColorCount(void *brush, void *count) { return 1; }

GD_PINVOKE_EXPORT int GdipGetPathGradientBlendCount(void *brush, void *count) { return 1; }

GD_PINVOKE_EXPORT int GdipGetPathGradientBlend(void *brush, float *blend, float *positions, int count) { return 1; }

GD_PINVOKE_EXPORT int GdipSetPathGradientBlend(void *brush, void *blend, void *positions, int count) { return 1; }

GD_PINVOKE_EXPORT int GdipGetPathGradientPresetBlendCount(void *brush, void *count) { return 1; }

GD_PINVOKE_EXPORT int GdipGetPathGradientPresetBlend(void *brush, int *blend, float *positions, int count) { return 1; }

GD_PINVOKE_EXPORT int GdipSetPathGradientPresetBlend(void *brush, int *blend, float *positions, int count) { return 1; }

GD_PINVOKE_EXPORT int GdipSetPathGradientSigmaBlend(void *brush, float focus, float scale) { return 1; }

GD_PINVOKE_EXPORT int GdipSetPathGradientLinearBlend(void *brush, float focus, float scale) { return 1; }

GD_PINVOKE_EXPORT int GdipSetPathGradientWrapMode(void *brush, int wrapmode) { return 1; }

GD_PINVOKE_EXPORT int GdipGetPathGradientWrapMode(void *brush, void *wrapmode) { return 1; }

GD_PINVOKE_EXPORT int GdipSetPathGradientTransform(void *brush, void *matrix) { return 1; }

GD_PINVOKE_EXPORT int GdipGetPathGradientTransform(void *brush, void *matrix) { return 1; }

GD_PINVOKE_EXPORT int GdipResetPathGradientTransform(void *brush) { return 1; }

GD_PINVOKE_EXPORT int GdipMultiplyPathGradientTransform(void *brush, void *matrix, int order) { return 1; }

GD_PINVOKE_EXPORT int GdipTranslatePathGradientTransform(void *brush, float dx, float dy, int order) { return 1; }

GD_PINVOKE_EXPORT int GdipScalePathGradientTransform(void *brush, float sx, float sy, int order) { return 1; }

GD_PINVOKE_EXPORT int GdipRotatePathGradientTransform(void *brush, float angle, int order) { return 1; }

GD_PINVOKE_EXPORT int GdipGetPathGradientFocusScales(void *brush, float *xScale, float *yScale) { return 1; }

GD_PINVOKE_EXPORT int GdipSetPathGradientFocusScales(void *brush, float xScale, float yScale) { return 1; }

GD_PINVOKE_EXPORT int GdipCreateImageAttributes(void *imageattr) { return 1; }

GD_PINVOKE_EXPORT int GdipCloneImageAttributes(void *imageattr, void *cloneImageattr) { return 1; }

GD_PINVOKE_EXPORT int GdipDisposeImageAttributes(void *imageattr) { return 1; }

GD_PINVOKE_EXPORT int GdipSetImageAttributesColorMatrix(void *imageattr, int type, bool enableFlag, int colorMatrix, int grayMatrix, int flags) { return 1; }

GD_PINVOKE_EXPORT int GdipSetImageAttributesThreshold(void *imageattr, int type, bool enableFlag, float threshold) { return 1; }

GD_PINVOKE_EXPORT int GdipSetImageAttributesGamma(void *imageattr, int type, bool enableFlag, float gamma) { return 1; }

GD_PINVOKE_EXPORT int GdipSetImageAttributesNoOp(void *imageattr, int type, bool enableFlag) { return 1; }

GD_PINVOKE_EXPORT int GdipSetImageAttributesColorKeys(void *imageattr, int type, bool enableFlag, int colorLow, int colorHigh) { return 1; }

GD_PINVOKE_EXPORT int GdipSetImageAttributesOutputChannel(void *imageattr, int type, bool enableFlag, int flags) { return 1; }

GD_PINVOKE_EXPORT int GdipSetImageAttributesOutputChannelColorProfile(void *imageattr, int type, bool enableFlag, char *colorProfileFilename) { return 1; }

GD_PINVOKE_EXPORT int GdipSetImageAttributesRemapTable(void *imageattr, int type, bool enableFlag, int mapSize, void *map) { return 1; }

GD_PINVOKE_EXPORT int GdipSetImageAttributesWrapMode(void *imageattr, int wrapmode, int argb, bool clamp) { return 1; }

GD_PINVOKE_EXPORT int GdipGetImageAttributesAdjustedPalette(void *imageattr, void *palette, int type) { return 1; }

GD_PINVOKE_EXPORT int GdipGetImageDecodersSize(void *numDecoders, void *size) { return 1; }

GD_PINVOKE_EXPORT int GdipGetImageDecoders(int numDecoders, int size, void *decoders) { return 1; }

GD_PINVOKE_EXPORT int GdipGetImageEncodersSize(void *numEncoders, void *size) { return 1; }

GD_PINVOKE_EXPORT int GdipGetImageEncoders(int numEncoders, int size, void *encoders) { return 1; }

GD_PINVOKE_EXPORT int GdipCreateSolidFill(int color, void *brush) { return 1; }

GD_PINVOKE_EXPORT int GdipSetSolidFillColor(void *brush, int color) { return 1; }

GD_PINVOKE_EXPORT int GdipGetSolidFillColor(void *brush, void *color) { return 1; }

GD_PINVOKE_EXPORT int GdipCreateTexture(void *bitmap, int wrapmode, void *texture) { return 1; }

GD_PINVOKE_EXPORT int GdipCreateTexture2(void *bitmap, int wrapmode, float x, float y, float width, float height, void *texture) { return 1; }

GD_PINVOKE_EXPORT int GdipCreateTextureIA(void *bitmap, void *imageAttrib, float x, float y, float width, float height, void *texture) { return 1; }

GD_PINVOKE_EXPORT int GdipCreateTexture2I(void *bitmap, int wrapmode, int x, int y, int width, int height, void *texture) { return 1; }

GD_PINVOKE_EXPORT int GdipCreateTextureIAI(void *bitmap, void *imageAttrib, int x, int y, int width, int height, void *texture) { return 1; }

GD_PINVOKE_EXPORT int GdipSetTextureTransform(void *brush, void *matrix) { return 1; }

GD_PINVOKE_EXPORT int GdipGetTextureTransform(void *brush, void *matrix) { return 1; }

GD_PINVOKE_EXPORT int GdipResetTextureTransform(void *brush) { return 1; }

GD_PINVOKE_EXPORT int GdipMultiplyTextureTransform(void *brush, void *matrix, int order) { return 1; }

GD_PINVOKE_EXPORT int GdipTranslateTextureTransform(void *brush, float dx, float dy, int order) { return 1; }

GD_PINVOKE_EXPORT int GdipScaleTextureTransform(void *brush, float sx, float sy, int order) { return 1; }

GD_PINVOKE_EXPORT int GdipRotateTextureTransform(void *brush, float angle, int order) { return 1; }

GD_PINVOKE_EXPORT int GdipSetTextureWrapMode(void *brush, int wrapMode) { return 1; }

GD_PINVOKE_EXPORT int GdipGetTextureWrapMode(void *brush, void *wrapMode) { return 1; }

GD_PINVOKE_EXPORT int GdipGetTextureImage(void *brush, void *image) { return 1; }

GD_PINVOKE_EXPORT int GdipGetFontCollectionFamilyCount(void *fontCollection, void *numFound) { return 1; }

GD_PINVOKE_EXPORT int GdipGetFontCollectionFamilyList(void *fontCollection, int numSought, void *gpfamilies, void *numFound) { return 1; }

GD_PINVOKE_EXPORT int GdipCloneFontFamily(void *fontfamily, void *clonefontfamily) { return 1; }

GD_PINVOKE_EXPORT int GdipCreateFontFamilyFromName(char *name, void *fontCollection, void *FontFamily) { return 1; }

GD_PINVOKE_EXPORT int GdipGetGenericFontFamilySansSerif(void *fontfamily) { return 1; }

GD_PINVOKE_EXPORT int GdipGetGenericFontFamilySerif(void *fontfamily) { return 1; }

GD_PINVOKE_EXPORT int GdipGetGenericFontFamilyMonospace(void *fontfamily) { return 1; }

GD_PINVOKE_EXPORT int GdipDeleteFontFamily(void *fontFamily) { return 1; }

GD_PINVOKE_EXPORT int GdipGetFamilyName(void *family, char *name, int language) { return 1; }

GD_PINVOKE_EXPORT int GdipIsStyleAvailable(void *family, int style, void *isStyleAvailable) { return 1; }

GD_PINVOKE_EXPORT int GdipGetEmHeight(void *family, int style, void *EmHeight) { return 1; }

GD_PINVOKE_EXPORT int GdipGetCellAscent(void *family, int style, void *CellAscent) { return 1; }

GD_PINVOKE_EXPORT int GdipGetCellDescent(void *family, int style, void *CellDescent) { return 1; }

GD_PINVOKE_EXPORT int GdipGetLineSpacing(void *family, int style, void *LineSpaceing) { return 1; }

GD_PINVOKE_EXPORT int GdipNewInstalledFontCollection(void *fontCollection) { return 1; }

GD_PINVOKE_EXPORT int GdipNewPrivateFontCollection(void *fontCollection) { return 1; }

GD_PINVOKE_EXPORT int GdipDeletePrivateFontCollection(void *fontCollection) { return 1; }

GD_PINVOKE_EXPORT int GdipPrivateAddFontFile(void *fontCollection, char *filename) { return 1; }

GD_PINVOKE_EXPORT int GdipPrivateAddMemoryFont(void *fontCollection, void *memory, int length) { return 1; }

GD_PINVOKE_EXPORT int GdipCreateFont(void *fontFamily, float emSize, int style, int unit, void *font) { return 1; }

GD_PINVOKE_EXPORT int GdipCreateFontFromDC(void *hdc, void *font) { return 1; }

GD_PINVOKE_EXPORT int GdipCloneFont(void *font, void *cloneFont) { return 1; }

GD_PINVOKE_EXPORT int GdipDeleteFont(void *font) { return 1; }

GD_PINVOKE_EXPORT int GdipGetFamily(void *font, void *family) { return 1; }

GD_PINVOKE_EXPORT int GdipGetFontStyle(void *font, int *style) { return 1; }

GD_PINVOKE_EXPORT int GdipGetFontSize(void *font, void *size) { return 1; }

GD_PINVOKE_EXPORT int GdipGetFontHeight(void *font, void *graphics, void *size) { return 1; }

GD_PINVOKE_EXPORT int GdipGetFontHeightGivenDPI(void *font, float dpi, void *size) { return 1; }

GD_PINVOKE_EXPORT int GdipGetFontUnit(void *font, int *unit) { return 1; }

GD_PINVOKE_EXPORT int GdipGetLogFontW(void *font, void *graphics, int lf) { return 1; }

GD_PINVOKE_EXPORT int GdipCreatePen1(int argb, float width, int unit, void *pen) { return 1; }

GD_PINVOKE_EXPORT int GdipCreatePen2(void *brush, float width, int unit, void *pen) { return 1; }

GD_PINVOKE_EXPORT int GdipClonePen(void *pen, void *clonepen) { return 1; }

GD_PINVOKE_EXPORT int GdipDeletePen(void *Pen) { return 1; }

GD_PINVOKE_EXPORT int GdipSetPenMode(void *pen, int penAlign) { return 1; }

GD_PINVOKE_EXPORT int GdipGetPenMode(void *pen, int *penAlign) { return 1; }

GD_PINVOKE_EXPORT int GdipSetPenWidth(void *pen, float width) { return 1; }

GD_PINVOKE_EXPORT int GdipGetPenWidth(void *pen, float *width) { return 1; }

GD_PINVOKE_EXPORT int GdipSetPenLineCap197819(void *pen, int startCap, int endCap, int dashCap) { return 1; }

GD_PINVOKE_EXPORT int GdipSetPenStartCap(void *pen, int startCap) { return 1; }

GD_PINVOKE_EXPORT int GdipSetPenEndCap(void *pen, int endCap) { return 1; }

GD_PINVOKE_EXPORT int GdipGetPenStartCap(void *pen, void *startCap) { return 1; }

GD_PINVOKE_EXPORT int GdipGetPenEndCap(void *pen, void *endCap) { return 1; }

GD_PINVOKE_EXPORT int GdipGetPenDashCap197819(void *pen, void *dashCap) { return 1; }

GD_PINVOKE_EXPORT int GdipSetPenDashCap197819(void *pen, int dashCap) { return 1; }

GD_PINVOKE_EXPORT int GdipSetPenLineJoin(void *pen, int lineJoin) { return 1; }

GD_PINVOKE_EXPORT int GdipGetPenLineJoin(void *pen, void *lineJoin) { return 1; }

GD_PINVOKE_EXPORT int GdipSetPenCustomStartCap(void *pen, void *customCap) { return 1; }

GD_PINVOKE_EXPORT int GdipGetPenCustomStartCap(void *pen, void *customCap) { return 1; }

GD_PINVOKE_EXPORT int GdipSetPenCustomEndCap(void *pen, void *customCap) { return 1; }

GD_PINVOKE_EXPORT int GdipGetPenCustomEndCap(void *pen, void *customCap) { return 1; }

GD_PINVOKE_EXPORT int GdipSetPenMiterLimit(void *pen, float miterLimit) { return 1; }

GD_PINVOKE_EXPORT int GdipGetPenMiterLimit(void *pen, float *miterLimit) { return 1; }

GD_PINVOKE_EXPORT int GdipSetPenTransform(void *pen, void *matrix) { return 1; }

GD_PINVOKE_EXPORT int GdipGetPenTransform(void *pen, void *matrix) { return 1; }

GD_PINVOKE_EXPORT int GdipResetPenTransform(void *brush) { return 1; }

GD_PINVOKE_EXPORT int GdipMultiplyPenTransform(void *brush, void *matrix, int order) { return 1; }

GD_PINVOKE_EXPORT int GdipTranslatePenTransform(void *brush, float dx, float dy, int order) { return 1; }

GD_PINVOKE_EXPORT int GdipScalePenTransform(void *brush, float sx, float sy, int order) { return 1; }

GD_PINVOKE_EXPORT int GdipRotatePenTransform(void *brush, float angle, int order) { return 1; }

GD_PINVOKE_EXPORT int GdipSetPenColor(void *pen, int argb) { return 1; }

GD_PINVOKE_EXPORT int GdipGetPenColor(void *pen, void *argb) { return 1; }

GD_PINVOKE_EXPORT int GdipSetPenBrushFill(void *pen, void *brush) { return 1; }

GD_PINVOKE_EXPORT int GdipGetPenBrushFill(void *pen, void *brush) { return 1; }

GD_PINVOKE_EXPORT int GdipGetPenFillType(void *pen, void *pentype) { return 1; }

GD_PINVOKE_EXPORT int GdipGetPenDashStyle(void *pen, void *dashstyle) { return 1; }

GD_PINVOKE_EXPORT int GdipSetPenDashStyle(void *pen, int dashstyle) { return 1; }

GD_PINVOKE_EXPORT int GdipSetPenDashArray(void *pen, void *memorydash, int count) { return 1; }

GD_PINVOKE_EXPORT int GdipGetPenDashOffset(void *pen, float *dashoffset) { return 1; }

GD_PINVOKE_EXPORT int GdipSetPenDashOffset(void *pen, float dashoffset) { return 1; }

GD_PINVOKE_EXPORT int GdipGetPenDashCount(void *pen, void *dashcount) { return 1; }

GD_PINVOKE_EXPORT int GdipGetPenDashArray(void *pen, float *memorydash, int count) { return 1; }

GD_PINVOKE_EXPORT int GdipGetPenCompoundCount(void *pen, void *count) { return 1; }

GD_PINVOKE_EXPORT int GdipSetPenCompoundArray(void *pen, float *array, int count) { return 1; }

GD_PINVOKE_EXPORT int GdipGetPenCompoundArray(void *pen, float *array, int count) { return 1; }

GD_PINVOKE_EXPORT int GdipSetWorldTransform(void *graphics, void *matrix) { return 1; }

GD_PINVOKE_EXPORT int GdipResetWorldTransform(void *graphics) { return 1; }

GD_PINVOKE_EXPORT int GdipMultiplyWorldTransform(void *graphics, void *matrix, int order) { return 1; }

GD_PINVOKE_EXPORT int GdipTranslateWorldTransform(void *graphics, float dx, float dy, int order) { return 1; }

GD_PINVOKE_EXPORT int GdipScaleWorldTransform(void *graphics, float sx, float sy, int order) { return 1; }

GD_PINVOKE_EXPORT int GdipRotateWorldTransform(void *graphics, float angle, int order) { return 1; }

GD_PINVOKE_EXPORT int GdipGetWorldTransform(void *graphics, void *matrix) { return 1; }

GD_PINVOKE_EXPORT int GdipSetCompositingMode(void *graphics, int compositingMode) { return 1; }

GD_PINVOKE_EXPORT int GdipSetTextRenderingHint(void *graphics, int textRenderingHint) { return 1; }

GD_PINVOKE_EXPORT int GdipSetTextContrast(void *graphics, int textContrast) { return 1; }

GD_PINVOKE_EXPORT int GdipSetInterpolationMode(void *graphics, int interpolationMode) { return 1; }

GD_PINVOKE_EXPORT int GdipGetCompositingMode(void *graphics, int *compositingMode) { return 1; }

GD_PINVOKE_EXPORT int GdipSetRenderingOrigin(void *graphics, int x, int y) { return 1; }

GD_PINVOKE_EXPORT int GdipGetRenderingOrigin(void *graphics, void *x, void *y) { return 1; }

GD_PINVOKE_EXPORT int GdipSetCompositingQuality(void *graphics, int quality) { return 1; }

GD_PINVOKE_EXPORT int GdipGetCompositingQuality(void *graphics, int *quality) { return 1; }

GD_PINVOKE_EXPORT int GdipSetSmoothingMode(void *graphics, int smoothingMode) { return 1; }

GD_PINVOKE_EXPORT int GdipGetSmoothingMode(void *graphics, int *smoothingMode) { return 1; }

GD_PINVOKE_EXPORT int GdipSetPixelOffsetMode(void *graphics, int pixelOffsetMode) { return 1; }

GD_PINVOKE_EXPORT int GdipGetPixelOffsetMode(void *graphics, int *pixelOffsetMode) { return 1; }

GD_PINVOKE_EXPORT int GdipGetTextRenderingHint(void *graphics, int *textRenderingHint) { return 1; }

GD_PINVOKE_EXPORT int GdipGetTextContrast(void *graphics, void *textContrast) { return 1; }

GD_PINVOKE_EXPORT int GdipGetInterpolationMode(void *graphics, void *interpolationMode) { return 1; }

GD_PINVOKE_EXPORT int GdipGetPageUnit(void *graphics, int *unit) { return 1; }

GD_PINVOKE_EXPORT int GdipGetPageScale(void *graphics, void *scale) { return 1; }

GD_PINVOKE_EXPORT int GdipSetPageUnit(void *graphics, int unit) { return 1; }

GD_PINVOKE_EXPORT int GdipSetPageScale(void *graphics, float scale) { return 1; }

GD_PINVOKE_EXPORT int GdipGetDpiX(void *graphics, void *dpi) { return 1; }

GD_PINVOKE_EXPORT int GdipGetDpiY(void *graphics, void *dpi) { return 1; }

GD_PINVOKE_EXPORT int GdipCreateMatrix(void *matrix) { return 1; }

GD_PINVOKE_EXPORT int GdipCreateMatrix2(float m11, float m12, float m21, float m22, float dx, float dy, void *matrix) { return 1; }

GD_PINVOKE_EXPORT int GdipCreateMatrix3(void *rect, void *dstplg, void *matrix) { return 1; }

GD_PINVOKE_EXPORT int GdipCreateMatrix3I(void *rect, void *dstplg, void *matrix) { return 1; }

GD_PINVOKE_EXPORT int GdipCloneMatrix(void *matrix, void *cloneMatrix) { return 1; }

GD_PINVOKE_EXPORT int GdipDeleteMatrix(void *matrix) { return 1; }

GD_PINVOKE_EXPORT int GdipSetMatrixElements(void *matrix, float m11, float m12, float m21, float m22, float dx, float dy) { return 1; }

GD_PINVOKE_EXPORT int GdipMultiplyMatrix(void *matrix, void *matrix2, int order) { return 1; }

GD_PINVOKE_EXPORT int GdipTranslateMatrix(void *matrix, float offsetX, float offsetY, int order) { return 1; }

GD_PINVOKE_EXPORT int GdipScaleMatrix(void *matrix, float scaleX, float scaleY, int order) { return 1; }

GD_PINVOKE_EXPORT int GdipRotateMatrix(void *matrix, float angle, int order) { return 1; }

GD_PINVOKE_EXPORT int GdipShearMatrix(void *matrix, float shearX, float shearY, int order) { return 1; }

GD_PINVOKE_EXPORT int GdipInvertMatrix(void *matrix) { return 1; }

GD_PINVOKE_EXPORT int GdipTransformMatrixPoints(void *matrix, void *pts, int count) { return 1; }

GD_PINVOKE_EXPORT int GdipTransformMatrixPointsI(void *matrix, void *pts, int count) { return 1; }

GD_PINVOKE_EXPORT int GdipVectorTransformMatrixPoints(void *matrix, void *pts, int count) { return 1; }

GD_PINVOKE_EXPORT int GdipVectorTransformMatrixPointsI(void *matrix, void *pts, int count) { return 1; }

GD_PINVOKE_EXPORT int GdipGetMatrixElements(void *matrix, float *m) { return 1; }

GD_PINVOKE_EXPORT int GdipIsMatrixInvertible(void *matrix, void *boolean) { return 1; }

GD_PINVOKE_EXPORT int GdipIsMatrixIdentity(void *matrix, void *boolean) { return 1; }

GD_PINVOKE_EXPORT int GdipIsMatrixEqual(void *matrix, void *matrix2, void *boolean) { return 1; }

GD_PINVOKE_EXPORT int GdipCreateRegion(void *region) { return 1; }

GD_PINVOKE_EXPORT int GdipCreateRegionRect(void *gprectf, void *region) { return 1; }

GD_PINVOKE_EXPORT int GdipCreateRegionRectI(void *gprect, void *region) { return 1; }

GD_PINVOKE_EXPORT int GdipCreateRegionPath(void *path, void *region) { return 1; }

GD_PINVOKE_EXPORT int GdipCreateRegionRgnData(char *rgndata, int size, void *region) { return 1; }

GD_PINVOKE_EXPORT int GdipCreateRegionHrgn(void *hRgn, void *region) { return 1; }

GD_PINVOKE_EXPORT int GdipCloneRegion(void *region, void *cloneregion) { return 1; }

GD_PINVOKE_EXPORT int GdipDeleteRegion(void *region) { return 1; }

GD_PINVOKE_EXPORT int GdipFillRegion(void *graphics, void *brush, void *region) { return 1; }

GD_PINVOKE_EXPORT int GdipSetInfinite(void *region) { return 1; }

GD_PINVOKE_EXPORT int GdipSetEmpty(void *region) { return 1; }

GD_PINVOKE_EXPORT int GdipCombineRegionRect(void *region, void *gprectf, int mode) { return 1; }

GD_PINVOKE_EXPORT int GdipCombineRegionRectI(void *region, void *gprect, int mode) { return 1; }

GD_PINVOKE_EXPORT int GdipCombineRegionPath(void *region, void *path, int mode) { return 1; }

GD_PINVOKE_EXPORT int GdipCombineRegionRegion(void *region, void *region2, int mode) { return 1; }

GD_PINVOKE_EXPORT int GdipTranslateRegion(void *region, float dx, float dy) { return 1; }

GD_PINVOKE_EXPORT int GdipTranslateRegionI(void *region, int dx, int dy) { return 1; }

GD_PINVOKE_EXPORT int GdipTransformRegion(void *region, void *matrix) { return 1; }

GD_PINVOKE_EXPORT int GdipGetRegionBounds(void *region, void *graphics, void *gprectf) { return 1; }

GD_PINVOKE_EXPORT int GdipGetRegionHRgn(void *region, void *graphics, void *hrgn) { return 1; }

GD_PINVOKE_EXPORT int GdipIsEmptyRegion(void *region, void *graphics, void *boolean) { return 1; }

GD_PINVOKE_EXPORT int GdipIsInfiniteRegion(void *region, void *graphics, void *boolean) { return 1; }

GD_PINVOKE_EXPORT int GdipIsEqualRegion(void *region, void *region2, void *graphics, void *boolean) { return 1; }

GD_PINVOKE_EXPORT int GdipGetRegionDataSize(void *region, void *bufferSize) { return 1; }

GD_PINVOKE_EXPORT int GdipGetRegionData(void *region, char *regionData, int bufferSize, void *sizeFilled) { return 1; }

GD_PINVOKE_EXPORT int GdipIsVisibleRegionPoint(void *region, float X, float Y, void *graphics, void *boolean) { return 1; }

GD_PINVOKE_EXPORT int GdipIsVisibleRegionPointI(void *region, int X, int Y, void *graphics, void *boolean) { return 1; }

GD_PINVOKE_EXPORT int GdipIsVisibleRegionRect(void *region, float X, float Y, float width, float height, void *graphics, void *boolean) { return 1; }

GD_PINVOKE_EXPORT int GdipIsVisibleRegionRectI(void *region, int X, int Y, int width, int height, void *graphics, void *boolean) { return 1; }

GD_PINVOKE_EXPORT int GdipGetRegionScansCount(void *region, void *count, void *matrix) { return 1; }

GD_PINVOKE_EXPORT int GdipGetRegionScans(void *region, void *rects, void *count, void *matrix) { return 1; }

GD_PINVOKE_EXPORT int GdipCreateFromHDC(void *hdc, void *graphics) { return 1; }

GD_PINVOKE_EXPORT int GdipSetClipGraphics(void *graphics, void *srcgraphics, int mode) { return 1; }

GD_PINVOKE_EXPORT int GdipSetClipRect(void *graphics, float x, float y, float width, float height, int mode) { return 1; }

GD_PINVOKE_EXPORT int GdipSetClipRectI(void *graphics, int x, int y, int width, int height, int mode) { return 1; }

GD_PINVOKE_EXPORT int GdipSetClipPath(void *graphics, void *path, int mode) { return 1; }

GD_PINVOKE_EXPORT int GdipSetClipRegion(void *graphics, void *region, int mode) { return 1; }

GD_PINVOKE_EXPORT int GdipResetClip(void *graphics) { return 1; }

GD_PINVOKE_EXPORT int GdipTranslateClip(void *graphics, float dx, float dy) { return 1; }

GD_PINVOKE_EXPORT int GdipGetClip(void *graphics, void *region) { return 1; }

GD_PINVOKE_EXPORT int GdipGetClipBounds(void *graphics, void *rect) { return 1; }

GD_PINVOKE_EXPORT int GdipIsClipEmpty(void *graphics, void *result) { return 1; }

GD_PINVOKE_EXPORT int GdipGetVisibleClipBounds(void *graphics, void *rect) { return 1; }

GD_PINVOKE_EXPORT int GdipIsVisibleClipEmpty(void *graphics, void *result) { return 1; }

GD_PINVOKE_EXPORT int GdipIsVisiblePoint(void *graphics, float x, float y, void *result) { return 1; }

GD_PINVOKE_EXPORT int GdipIsVisiblePointI(void *graphics, int x, int y, void *result) { return 1; }

GD_PINVOKE_EXPORT int GdipIsVisibleRect(void *graphics, float x, float y, float width, float height, void *result) { return 1; }

GD_PINVOKE_EXPORT int GdipIsVisibleRectI(void *graphics, int x, int y, int width, int height, void *result) { return 1; }

GD_PINVOKE_EXPORT int GdipFlush(void *graphics, int intention) { return 1; }

GD_PINVOKE_EXPORT int GdipGetDC(void *graphics, void *hdc) { return 1; }

GD_PINVOKE_EXPORT int GdipSetStringFormatMeasurableCharacterRanges(void *format, int rangeCount, void *range) { return 1; }

GD_PINVOKE_EXPORT int GdipCreateStringFormat(int options, int language, void *format) { return 1; }

GD_PINVOKE_EXPORT int GdipStringFormatGetGenericDefault(void *format) { return 1; }

GD_PINVOKE_EXPORT int GdipStringFormatGetGenericTypographic(void *format) { return 1; }

GD_PINVOKE_EXPORT int GdipDeleteStringFormat(void *format) { return 1; }

GD_PINVOKE_EXPORT int GdipCloneStringFormat(void *format, void *newFormat) { return 1; }

GD_PINVOKE_EXPORT int GdipSetStringFormatFlags(void *format, int options) { return 1; }

GD_PINVOKE_EXPORT int GdipGetStringFormatFlags(void *format, int *result) { return 1; }

GD_PINVOKE_EXPORT int GdipSetStringFormatAlign(void *format, int align) { return 1; }

GD_PINVOKE_EXPORT int GdipGetStringFormatAlign(void *format, void *align) { return 1; }

GD_PINVOKE_EXPORT int GdipSetStringFormatLineAlign(void *format, int align) { return 1; }

GD_PINVOKE_EXPORT int GdipGetStringFormatLineAlign(void *format, void *align) { return 1; }

GD_PINVOKE_EXPORT int GdipSetStringFormatHotkeyPrefix(void *format, int hotkeyPrefix) { return 1; }

GD_PINVOKE_EXPORT int GdipGetStringFormatHotkeyPrefix(void *format, void *hotkeyPrefix) { return 1; }

GD_PINVOKE_EXPORT int GdipSetStringFormatTabStops(void *format, float firstTabOffset, int count, float *tabStops) { return 1; }

GD_PINVOKE_EXPORT int GdipGetStringFormatTabStops(void *format, int count, void *firstTabOffset, float *tabStops) { return 1; }

GD_PINVOKE_EXPORT int GdipGetStringFormatTabStopCount(void *format, void *count) { return 1; }

GD_PINVOKE_EXPORT int GdipGetStringFormatMeasurableCharacterRangeCount(void *format, void *count) { return 1; }

GD_PINVOKE_EXPORT int GdipSetStringFormatTrimming(void *format, int trimming) { return 1; }

GD_PINVOKE_EXPORT int GdipGetStringFormatTrimming(void *format, void *trimming) { return 1; }

GD_PINVOKE_EXPORT int GdipSetStringFormatDigitSubstitution(void *format, int langID, int sds) { return 1; }

GD_PINVOKE_EXPORT int GdipGetStringFormatDigitSubstitution(void *format, void *langID, void *sds) { return 1; }

GD_PINVOKE_EXPORT int GdipGetImageDimension(void *image, void *width, void *height) { return 1; }

GD_PINVOKE_EXPORT int GdipGetImageWidth(void *image, void *width) { return 1; }

GD_PINVOKE_EXPORT int GdipGetImageHeight(void *image, void *height) { return 1; }

GD_PINVOKE_EXPORT int GdipGetImageHorizontalResolution(void *image, void *horzRes) { return 1; }

GD_PINVOKE_EXPORT int GdipGetImageVerticalResolution(void *image, void *vertRes) { return 1; }

GD_PINVOKE_EXPORT int GdipGetImageFlags(void *image, void *flags) { return 1; }

GD_PINVOKE_EXPORT int GdipGetImageRawFormat(void *image, int format) { return 1; }

GD_PINVOKE_EXPORT int GdipGetImagePixelFormat(void *image, void *format) { return 1; }

GD_PINVOKE_EXPORT int GdipImageGetFrameCount(void *image, int dimensionID, void *count) { return 1; }

GD_PINVOKE_EXPORT int GdipImageSelectActiveFrame(void *image, int dimensionID, int frameIndex) { return 1; }

GD_PINVOKE_EXPORT int GdipImageRotateFlip(void *image, int rotateFlipType) { return 1; }

GD_PINVOKE_EXPORT int GdipGetAllPropertyItems(void *image, unsigned int totalBufferSize, unsigned int numProperties, void *allItems) { return 1; }

GD_PINVOKE_EXPORT int GdipGetPropertyCount(void *image, unsigned int *numOfProperty) { return 1; }

GD_PINVOKE_EXPORT int GdipGetPropertyIdList(void *image, unsigned int numOfProperty, int *list) { return 1; }

GD_PINVOKE_EXPORT int GdipGetPropertyItem(void *image, int propid, unsigned int propSize, void *buffer) { return 1; }

GD_PINVOKE_EXPORT int GdipGetPropertyItemSize(void *image, int propid, unsigned int *size) { return 1; }

GD_PINVOKE_EXPORT int GdipGetPropertySize(void *image, unsigned int *totalBufferSize, unsigned int *numProperties) { return 1; }

GD_PINVOKE_EXPORT int GdipRemovePropertyItem(void *image, int propid) { return 1; }

GD_PINVOKE_EXPORT int GdipSetPropertyItem(void *image, void *item) { return 1; }

GD_PINVOKE_EXPORT int GdipGetImageType(void *image, void *type) { return 1; }

// GD_PINVOKE_EXPORT int GdipGetImageType(void * image, void * type){ return 1; }

GD_PINVOKE_EXPORT int GdipDisposeImage(void *image) { return 1; }

// GD_PINVOKE_EXPORT int GdipDisposeImage(void * image){ return 1; }

GD_PINVOKE_EXPORT int GdipCreateBitmapFromFile(char *filename, void *bitmap) { return 1; }

GD_PINVOKE_EXPORT int GdipCreateBitmapFromFileICM(char *filename, void *bitmap) { return 1; }

GD_PINVOKE_EXPORT int GdipCreateBitmapFromScan0(int width, int height, int stride, int format, void *scan0, void *bitmap) { return 1; }

GD_PINVOKE_EXPORT int GdipCreateBitmapFromGraphics(int width, int height, void *graphics, void *bitmap) { return 1; }

GD_PINVOKE_EXPORT int GdipCreateBitmapFromHBITMAP(void *hbitmap, void *hpalette, void *bitmap) { return 1; }

GD_PINVOKE_EXPORT int GdipCreateBitmapFromHICON(void *hicon, void *bitmap) { return 1; }

GD_PINVOKE_EXPORT int GdipCreateBitmapFromResource(void *hresource, void *name, void *bitmap) { return 1; }

GD_PINVOKE_EXPORT int GdipCreateHBITMAPFromBitmap(void *nativeBitmap, void *hbitmap, int argbBackground) { return 1; }

GD_PINVOKE_EXPORT int GdipCreateHICONFromBitmap(void *nativeBitmap, void *hicon) { return 1; }

GD_PINVOKE_EXPORT int GdipCloneBitmapArea(float x, float y, float width, float height, int format, void *srcbitmap, void *dstbitmap) { return 1; }

GD_PINVOKE_EXPORT int GdipCloneBitmapAreaI(int x, int y, int width, int height, int format, void *srcbitmap, void *dstbitmap) { return 1; }

GD_PINVOKE_EXPORT int GdipBitmapLockBits(void *bitmap, void *rect, int flags, int format, void *lockedBitmapData) { return 1; }

GD_PINVOKE_EXPORT int GdipBitmapUnlockBits(void *bitmap, int lockedBitmapData) { return 1; }

GD_PINVOKE_EXPORT int GdipBitmapGetPixel(void *bitmap, int x, int y, void *argb) { return 1; }

GD_PINVOKE_EXPORT int GdipBitmapSetPixel(void *bitmap, int x, int y, int argb) { return 1; }

GD_PINVOKE_EXPORT int GdipBitmapSetResolution(void *bitmap, float dpix, float dpiy) { return 1; }

GD_PINVOKE_EXPORT int GdipImageGetFrameDimensionsCount(void *image, void *count) { return 1; }

GD_PINVOKE_EXPORT int GdipImageGetFrameDimensionsList(void *image, int *dimensionIDs, int count) { return 1; }

GD_PINVOKE_EXPORT int GdipCreateMetafileFromEmf(void *hEnhMetafile, bool deleteEmf, void *metafile) { return 1; }

GD_PINVOKE_EXPORT int GdipCreateMetafileFromWmf(void *hMetafile, bool deleteWmf, int wmfplacealbeHeader, void *metafile) { return 1; }

GD_PINVOKE_EXPORT int GdipCreateMetafileFromFile(char *file, void *metafile) { return 1; }

GD_PINVOKE_EXPORT int GdipRecordMetafile(void *referenceHdc, int emfType, void *pframeRect, int frameUnit, char *description, void *metafile) { return 1; }

// GD_PINVOKE_EXPORT int GdipRecordMetafile(void * referenceHdc, int emfType, void * frameRect, int frameUnit, char * description, void * metafile){ return 1; }

GD_PINVOKE_EXPORT int GdipRecordMetafileI(void *referenceHdc, int emfType, void *frameRect, int frameUnit, char *description, void *metafile) { return 1; }

GD_PINVOKE_EXPORT int GdipRecordMetafileFileName(char *fileName, void *referenceHdc, int emfType, void *frameRect, int frameUnit, char *description, void *metafile) { return 1; }

// GD_PINVOKE_EXPORT int GdipRecordMetafileFileName(char * fileName, void * referenceHdc, int emfType, void * pframeRect, int frameUnit, char * description, void * metafile){ return 1; }

GD_PINVOKE_EXPORT int GdipRecordMetafileFileNameI(char *fileName, void *referenceHdc, int emfType, void *frameRect, int frameUnit, char *description, void *metafile) { return 1; }

GD_PINVOKE_EXPORT int GdipPlayMetafileRecord(void *metafile, int recordType, int flags, int dataSize, char *data) { return 1; }

GD_PINVOKE_EXPORT int GdipSaveGraphics(void *graphics, void *state) { return 1; }

GD_PINVOKE_EXPORT int GdipDrawArc(void *graphics, void *pen, float x, float y, float width, float height, float startAngle, float sweepAngle) { return 1; }

GD_PINVOKE_EXPORT int GdipDrawArcI(void *graphics, void *pen, int x, int y, int width, int height, float startAngle, float sweepAngle) { return 1; }

GD_PINVOKE_EXPORT int GdipDrawLinesI(void *graphics, void *pen, void *points, int count) { return 1; }

GD_PINVOKE_EXPORT int GdipDrawBezier(void *graphics, void *pen, float x1, float y1, float x2, float y2, float x3, float y3, float x4, float y4) { return 1; }

GD_PINVOKE_EXPORT int GdipDrawEllipse(void *graphics, void *pen, float x, float y, float width, float height) { return 1; }

GD_PINVOKE_EXPORT int GdipDrawEllipseI(void *graphics, void *pen, int x, int y, int width, int height) { return 1; }

GD_PINVOKE_EXPORT int GdipDrawLine(void *graphics, void *pen, float x1, float y1, float x2, float y2) { return 1; }

GD_PINVOKE_EXPORT int GdipDrawLineI(void *graphics, void *pen, int x1, int y1, int x2, int y2) { return 1; }

GD_PINVOKE_EXPORT int GdipDrawLines(void *graphics, void *pen, void *points, int count) { return 1; }

GD_PINVOKE_EXPORT int GdipDrawPath(void *graphics, void *pen, void *path) { return 1; }

GD_PINVOKE_EXPORT int GdipDrawPie(void *graphics, void *pen, float x, float y, float width, float height, float startAngle, float sweepAngle) { return 1; }

GD_PINVOKE_EXPORT int GdipDrawPieI(void *graphics, void *pen, int x, int y, int width, int height, float startAngle, float sweepAngle) { return 1; }

GD_PINVOKE_EXPORT int GdipDrawPolygon(void *graphics, void *pen, void *points, int count) { return 1; }

GD_PINVOKE_EXPORT int GdipDrawPolygonI(void *graphics, void *pen, void *points, int count) { return 1; }

GD_PINVOKE_EXPORT int GdipFillEllipse(void *graphics, void *brush, float x, float y, float width, float height) { return 1; }

GD_PINVOKE_EXPORT int GdipFillEllipseI(void *graphics, void *brush, int x, int y, int width, int height) { return 1; }

GD_PINVOKE_EXPORT int GdipFillPolygon(void *graphics, void *brush, void *points, int count, int brushMode) { return 1; }

GD_PINVOKE_EXPORT int GdipFillPolygonI(void *graphics, void *brush, void *points, int count, int brushMode) { return 1; }

GD_PINVOKE_EXPORT int GdipFillRectangle(void *graphics, void *brush, float x, float y, float width, float height) { return 1; }

GD_PINVOKE_EXPORT int GdipFillRectangleI(void *graphics, void *brush, int x, int y, int width, int height) { return 1; }

GD_PINVOKE_EXPORT int GdipFillRectangles(void *graphics, void *brush, void *rects, int count) { return 1; }

GD_PINVOKE_EXPORT int GdipFillRectanglesI(void *graphics, void *brush, void *rects, int count) { return 1; }

GD_PINVOKE_EXPORT int GdipDrawString(void *graphics, char *textString, int length, void *font, void *layoutRect, void *stringFormat, void *brush) { return 1; }

GD_PINVOKE_EXPORT int GdipDrawImageRectI(void *graphics, void *image, int x, int y, int width, int height) { return 1; }

GD_PINVOKE_EXPORT int GdipGraphicsClear(void *graphics, int argb) { return 1; }

GD_PINVOKE_EXPORT int GdipDrawClosedCurve(void *graphics, void *pen, void *points, int count) { return 1; }

GD_PINVOKE_EXPORT int GdipDrawClosedCurveI(void *graphics, void *pen, void *points, int count) { return 1; }

GD_PINVOKE_EXPORT int GdipDrawClosedCurve2(void *graphics, void *pen, void *points, int count, float tension) { return 1; }

GD_PINVOKE_EXPORT int GdipDrawClosedCurve2I(void *graphics, void *pen, void *points, int count, float tension) { return 1; }

GD_PINVOKE_EXPORT int GdipDrawCurve(void *graphics, void *pen, void *points, int count) { return 1; }

GD_PINVOKE_EXPORT int GdipDrawCurveI(void *graphics, void *pen, void *points, int count) { return 1; }

GD_PINVOKE_EXPORT int GdipDrawCurve2(void *graphics, void *pen, void *points, int count, float tension) { return 1; }

GD_PINVOKE_EXPORT int GdipDrawCurve2I(void *graphics, void *pen, void *points, int count, float tension) { return 1; }

GD_PINVOKE_EXPORT int GdipDrawCurve3(void *graphics, void *pen, void *points, int count, int offset, int numberOfSegments, float tension) { return 1; }

GD_PINVOKE_EXPORT int GdipDrawCurve3I(void *graphics, void *pen, void *points, int count, int offset, int numberOfSegments, float tension) { return 1; }

GD_PINVOKE_EXPORT int GdipFillClosedCurve(void *graphics, void *brush, void *points, int count) { return 1; }

GD_PINVOKE_EXPORT int GdipFillClosedCurveI(void *graphics, void *brush, void *points, int count) { return 1; }

GD_PINVOKE_EXPORT int GdipFillClosedCurve2(void *graphics, void *brush, void *points, int count, float tension, int mode) { return 1; }

GD_PINVOKE_EXPORT int GdipFillClosedCurve2I(void *graphics, void *brush, void *points, int count, float tension, int mode) { return 1; }

GD_PINVOKE_EXPORT int GdipFillPie(void *graphics, void *brush, float x, float y, float width, float height, float startAngle, float sweepAngle) { return 1; }

GD_PINVOKE_EXPORT int GdipFillPieI(void *graphics, void *brush, int x, int y, int width, int height, float startAngle, float sweepAngle) { return 1; }

GD_PINVOKE_EXPORT int GdipMeasureString(void *graphics, char *textString, int length, void *font, void *layoutRect, void *stringFormat, void *boundingBox, void *codepointsFitted, void *linesFilled) { return 1; }

GD_PINVOKE_EXPORT int GdipMeasureCharacterRanges(void *graphics, char *textString, int length, void *font, void *layoutRect, void *stringFormat, int characterCount, void *region) { return 1; }

GD_PINVOKE_EXPORT int GdipDrawImageI(void *graphics, void *image, int x, int y) { return 1; }

GD_PINVOKE_EXPORT int GdipDrawImage(void *graphics, void *image, float x, float y) { return 1; }

GD_PINVOKE_EXPORT int GdipDrawImagePoints(void *graphics, void *image, void *points, int count) { return 1; }

GD_PINVOKE_EXPORT int GdipDrawImagePointsI(void *graphics, void *image, void *points, int count) { return 1; }

GD_PINVOKE_EXPORT int GdipDrawImageRectRectI(void *graphics, void *image, int dstx, int dsty, int dstwidth, int dstheight, int srcx, int srcy, int srcwidth, int srcheight, int srcunit, void *imageAttributes, void *callback, void *callbackdata) { return 1; }

GD_PINVOKE_EXPORT int GdipDrawImagePointsRect(void *graphics, void *image, void *points, int count, float srcx, float srcy, float srcwidth, float srcheight, int srcunit, void *imageAttributes, void *callback, void *callbackdata) { return 1; }

GD_PINVOKE_EXPORT int GdipDrawImageRectRect(void *graphics, void *image, float dstx, float dsty, float dstwidth, float dstheight, float srcx, float srcy, float srcwidth, float srcheight, int srcunit, void *imageAttributes, void *callback, void *callbackdata) { return 1; }

GD_PINVOKE_EXPORT int GdipDrawImagePointsRectI(void *graphics, void *image, void *points, int count, int srcx, int srcy, int srcwidth, int srcheight, int srcunit, void *imageAttributes, void *callback, void *callbackdata) { return 1; }

GD_PINVOKE_EXPORT int GdipDrawImageRect(void *graphics, void *image, float x, float y, float width, float height) { return 1; }

GD_PINVOKE_EXPORT int GdipDrawImagePointRect(void *graphics, void *image, float x, float y, float srcx, float srcy, float srcwidth, float srcheight, int srcunit) { return 1; }

GD_PINVOKE_EXPORT int GdipDrawImagePointRectI(void *graphics, void *image, int x, int y, int srcx, int srcy, int srcwidth, int srcheight, int srcunit) { return 1; }

GD_PINVOKE_EXPORT int GdipDrawRectangle(void *graphics, void *pen, float x, float y, float width, float height) { return 1; }

GD_PINVOKE_EXPORT int GdipDrawRectangleI(void *graphics, void *pen, int x, int y, int width, int height) { return 1; }

GD_PINVOKE_EXPORT int GdipDrawRectangles(void *graphics, void *pen, void *rects, int count) { return 1; }

GD_PINVOKE_EXPORT int GdipDrawRectanglesI(void *graphics, void *pen, void *rects, int count) { return 1; }

GD_PINVOKE_EXPORT int GdipTransformPoints(void *graphics, int destSpace, int srcSpace, void *points, int count) { return 1; }

GD_PINVOKE_EXPORT int GdipTransformPointsI(void *graphics, int destSpace, int srcSpace, void *points, int count) { return 1; }

GD_PINVOKE_EXPORT int GdipLoadImageFromFileICM(char *filename, void *image) { return 1; }

GD_PINVOKE_EXPORT int GdipLoadImageFromFile(char *filename, void *image) { return 1; }

GD_PINVOKE_EXPORT int GdipGetEncoderParameterListSize(void *image, int encoder, void *size) { return 1; }

GD_PINVOKE_EXPORT int GdipGetEncoderParameterList(void *image, int encoder, int size, void *buffer) { return 1; }

GD_PINVOKE_EXPORT int GdiplusStartup(void *token, void *input, void *output) { return 1; }

GD_PINVOKE_EXPORT void GdiplusShutdown(void *token) {}

GD_PINVOKE_EXPORT void *GdipAlloc(int size) { return NULL; }

GD_PINVOKE_EXPORT void GdipFree(void *ptr) {}

GD_PINVOKE_EXPORT int GdipDeleteBrush(void *brush) { return 1; }

GD_PINVOKE_EXPORT int GdipGetBrushType(void *brush, void *type) { return 1; }

GD_PINVOKE_EXPORT int GdipDeleteGraphics(void *graphics) { return 1; }

GD_PINVOKE_EXPORT int GdipRestoreGraphics(void *graphics, uint graphicsState) { return 1; }

GD_PINVOKE_EXPORT int GdipReleaseDC(void *graphics, void *hdc) { return 1; }

GD_PINVOKE_EXPORT int GdipFillPath(void *graphics, void *brush, void *path) { return 1; }

GD_PINVOKE_EXPORT int GdipGetNearestColor(void *graphics, void *argb) { return 1; }

GD_PINVOKE_EXPORT int GdipAddPathString(void *path, char *s, int lenght, void *family, int style, float emSize, void *layoutRect, void *format) { return 1; }

GD_PINVOKE_EXPORT int GdipAddPathStringI(void *path, char *s, int lenght, void *family, int style, float emSize, void *layoutRect, void *format) { return 1; }

GD_PINVOKE_EXPORT int GdipCreateFromHWND(void *hwnd, void *graphics) { return 1; }

GD_PINVOKE_EXPORT int GdipCloneImage(void *image, void *imageclone) { return 1; }

GD_PINVOKE_EXPORT int GdipGetImagePaletteSize(void *image, void *size) { return 1; }

GD_PINVOKE_EXPORT int GdipGetImagePalette(void *image, void *palette, int size) { return 1; }

GD_PINVOKE_EXPORT int GdipSetImagePalette(void *image, void *palette) { return 1; }

GD_PINVOKE_EXPORT int GdipGetImageBounds(void *image, void *source, void *unit) { return 1; }

GD_PINVOKE_EXPORT int GdipGetImageThumbnail(void *image, uint width, uint height, void *thumbImage, void *callback, void *callBackData) { return 1; }

GD_PINVOKE_EXPORT int GdipSaveImageToFile(void *image, char *filename, void *encoderClsID, void *encoderParameters) { return 1; }

GD_PINVOKE_EXPORT int GdipSaveAdd(void *image, void *encoderParameters) { return 1; }

GD_PINVOKE_EXPORT int GdipSaveAddImage(void *image, void *imagenew, void *encoderParameters) { return 1; }

GD_PINVOKE_EXPORT int GdipGetImageGraphicsContext(void *image, void *graphics) { return 1; }

GD_PINVOKE_EXPORT int GdipCreatePath(int brushMode, void *path) { return 1; }

GD_PINVOKE_EXPORT int GdipCreatePath2(void *points, char *types, int count, int brushMode, void *path) { return 1; }

GD_PINVOKE_EXPORT int GdipCreatePath2I(void *points, char *types, int count, int brushMode, void *path) { return 1; }

GD_PINVOKE_EXPORT int GdipClonePath(void *path, void *clonePath) { return 1; }

GD_PINVOKE_EXPORT int GdipDeletePath(void *path) { return 1; }

GD_PINVOKE_EXPORT int GdipResetPath(void *path) { return 1; }

GD_PINVOKE_EXPORT int GdipGetPointCount(void *path, void *count) { return 1; }

GD_PINVOKE_EXPORT int GdipGetPathTypes(void *path, char *types, int count) { return 1; }

GD_PINVOKE_EXPORT int GdipGetPathPoints(void *path, void *points, int count) { return 1; }

GD_PINVOKE_EXPORT int GdipGetPathPointsI(void *path, void *points, int count) { return 1; }

GD_PINVOKE_EXPORT int GdipGetPathFillMode(void *path, int *fillMode) { return 1; }

GD_PINVOKE_EXPORT int GdipSetPathFillMode(void *path, int fillMode) { return 1; }

GD_PINVOKE_EXPORT int GdipStartPathFigure(void *path) { return 1; }

GD_PINVOKE_EXPORT int GdipClosePathFigure(void *path) { return 1; }

GD_PINVOKE_EXPORT int GdipClosePathFigures(void *path) { return 1; }

GD_PINVOKE_EXPORT int GdipSetPathMarker(void *path) { return 1; }

GD_PINVOKE_EXPORT int GdipClearPathMarkers(void *path) { return 1; }

GD_PINVOKE_EXPORT int GdipReversePath(void *path) { return 1; }

GD_PINVOKE_EXPORT int GdipGetPathLastPoint(void *path, void *lastPoint) { return 1; }

GD_PINVOKE_EXPORT int GdipAddPathLine(void *path, float x1, float y1, float x2, float y2) { return 1; }

GD_PINVOKE_EXPORT int GdipAddPathLine2(void *path, void *points, int count) { return 1; }

GD_PINVOKE_EXPORT int GdipAddPathLine2I(void *path, void *points, int count) { return 1; }

GD_PINVOKE_EXPORT int GdipAddPathArc(void *path, float x, float y, float width, float height, float startAngle, float sweepAngle) { return 1; }

GD_PINVOKE_EXPORT int GdipAddPathBezier(void *path, float x1, float y1, float x2, float y2, float x3, float y3, float x4, float y4) { return 1; }

GD_PINVOKE_EXPORT int GdipAddPathBeziers(void *path, void *points, int count) { return 1; }

GD_PINVOKE_EXPORT int GdipAddPathCurve(void *path, void *points, int count) { return 1; }

GD_PINVOKE_EXPORT int GdipAddPathCurveI(void *path, void *points, int count) { return 1; }

GD_PINVOKE_EXPORT int GdipAddPathCurve2(void *path, void *points, int count, float tension) { return 1; }

GD_PINVOKE_EXPORT int GdipAddPathCurve2I(void *path, void *points, int count, float tension) { return 1; }

GD_PINVOKE_EXPORT int GdipAddPathCurve3(void *path, void *points, int count, int offset, int numberOfSegments, float tension) { return 1; }

GD_PINVOKE_EXPORT int GdipAddPathCurve3I(void *path, void *points, int count, int offset, int numberOfSegments, float tension) { return 1; }

GD_PINVOKE_EXPORT int GdipAddPathClosedCurve(void *path, void *points, int count) { return 1; }

GD_PINVOKE_EXPORT int GdipAddPathClosedCurveI(void *path, void *points, int count) { return 1; }

GD_PINVOKE_EXPORT int GdipAddPathClosedCurve2(void *path, void *points, int count, float tension) { return 1; }

GD_PINVOKE_EXPORT int GdipAddPathClosedCurve2I(void *path, void *points, int count, float tension) { return 1; }

GD_PINVOKE_EXPORT int GdipAddPathRectangle(void *path, float x, float y, float width, float height) { return 1; }

GD_PINVOKE_EXPORT int GdipAddPathRectangles(void *path, void *rects, int count) { return 1; }

GD_PINVOKE_EXPORT int GdipAddPathEllipse(void *path, float x, float y, float width, float height) { return 1; }

GD_PINVOKE_EXPORT int GdipAddPathEllipseI(void *path, int x, int y, int width, int height) { return 1; }

GD_PINVOKE_EXPORT int GdipAddPathPie(void *path, float x, float y, float width, float height, float startAngle, float sweepAngle) { return 1; }

GD_PINVOKE_EXPORT int GdipAddPathPieI(void *path, int x, int y, int width, int height, float startAngle, float sweepAngle) { return 1; }

GD_PINVOKE_EXPORT int GdipAddPathPolygon(void *path, void *points, int count) { return 1; }

GD_PINVOKE_EXPORT int GdipAddPathPath(void *path, void *addingPath, bool connect) { return 1; }

GD_PINVOKE_EXPORT int GdipAddPathLineI(void *path, int x1, int y1, int x2, int y2) { return 1; }

GD_PINVOKE_EXPORT int GdipAddPathArcI(void *path, int x, int y, int width, int height, float startAngle, float sweepAngle) { return 1; }

GD_PINVOKE_EXPORT int GdipAddPathBezierI(void *path, int x1, int y1, int x2, int y2, int x3, int y3, int x4, int y4) { return 1; }

GD_PINVOKE_EXPORT int GdipAddPathBeziersI(void *path, void *points, int count) { return 1; }

GD_PINVOKE_EXPORT int GdipAddPathPolygonI(void *path, void *points, int count) { return 1; }

GD_PINVOKE_EXPORT int GdipAddPathRectangleI(void *path, int x, int y, int width, int height) { return 1; }

GD_PINVOKE_EXPORT int GdipAddPathRectanglesI(void *path, void *rects, int count) { return 1; }

GD_PINVOKE_EXPORT int GdipFlattenPath(void *path, void *matrix, float floatness) { return 1; }

GD_PINVOKE_EXPORT int GdipTransformPath(void *path, void *matrix) { return 1; }

GD_PINVOKE_EXPORT int GdipWarpPath(void *path, void *matrix, void *points, int count, float srcx, float srcy, float srcwidth, float srcheight, int mode, float flatness) { return 1; }

GD_PINVOKE_EXPORT int GdipWidenPath(void *path, void *pen, void *matrix, float flatness) { return 1; }

GD_PINVOKE_EXPORT int GdipGetPathWorldBounds(void *path, void *bounds, void *matrix, void *pen) { return 1; }

GD_PINVOKE_EXPORT int GdipGetPathWorldBoundsI(void *path, void *bounds, void *matrix, void *pen) { return 1; }

GD_PINVOKE_EXPORT int GdipIsVisiblePathPoint(void *path, float x, float y, void *graphics, void *result) { return 1; }

GD_PINVOKE_EXPORT int GdipIsVisiblePathPointI(void *path, int x, int y, void *graphics, void *result) { return 1; }

GD_PINVOKE_EXPORT int GdipIsOutlineVisiblePathPoint(void *path, float x, float y, void *pen, void *graphics, void *result) { return 1; }

GD_PINVOKE_EXPORT int GdipIsOutlineVisiblePathPointI(void *path, int x, int y, void *pen, void *graphics, void *result) { return 1; }

GD_PINVOKE_EXPORT int GdipCreateFontFromLogfont(void *hdc, void *lf, void *ptr) { return 1; }

GD_PINVOKE_EXPORT int GdipCreateFontFromHfont(void *hdc, void *font, void *lf) { return 1; }

GD_PINVOKE_EXPORT int GdipGetMetafileHeaderFromFile(char *filename, void *header) { return 1; }

GD_PINVOKE_EXPORT int GdipGetMetafileHeaderFromMetafile(void *metafile, void *header) { return 1; }

GD_PINVOKE_EXPORT int GdipGetMetafileHeaderFromEmf(void *hEmf, void *header) { return 1; }

GD_PINVOKE_EXPORT int GdipGetMetafileHeaderFromWmf(void *hWmf, void *wmfPlaceableFileHeader, void *header) { return 1; }

GD_PINVOKE_EXPORT int GdipGetHemfFromMetafile(void *metafile, void *hEmf) { return 1; }

GD_PINVOKE_EXPORT int GdipGetMetafileDownLevelRasterizationLimit(void *metafile, void *metafileRasterizationLimitDpi) { return 1; }

GD_PINVOKE_EXPORT int GdipSetMetafileDownLevelRasterizationLimit(void *metafile, uint metafileRasterizationLimitDpi) { return 1; }

GD_PINVOKE_EXPORT int GdipCreateFromContext_macosx(void *cgref, int width, int height, void *graphics) { return 1; }

GD_PINVOKE_EXPORT int GdipSetVisibleClip_linux(void *graphics, void *rect) { return 1; }

GD_PINVOKE_EXPORT int GdipCreateFromXDrawable_linux(void *drawable, void *display, void *graphics) { return 1; }

// Stream functions for non-Win32 (libgdiplus specific)

GD_PINVOKE_EXPORT int GdipLoadImageFromDelegate_linux(void *getHeader,
                                                      void *getBytes, void *putBytes, void *doSeek,
                                                      void *close, int size, void *image) { return 1; }

GD_PINVOKE_EXPORT int GdipSaveImageToDelegate_linux(void *image, void *getBytes,
                                                    void *putBytes, void *doSeek, void *close,
                                                    int size, void *encoderClsID, void *encoderParameters) { return 1; }

GD_PINVOKE_EXPORT int GdipCreateMetafileFromDelegate_linux(void *getHeader,
                                                           void *getBytes, void *putBytes, void *doSeek,
                                                           void *close, int size, void *metafile) { return 1; }

GD_PINVOKE_EXPORT int GdipGetMetafileHeaderFromDelegate_linux(void *getHeader,
                                                              void *getBytes, void *putBytes, void *doSeek,
                                                              void *close, int size, void *header) { return 1; }

GD_PINVOKE_EXPORT int GdipRecordMetafileFromDelegate_linux(void *getHeader,
                                                           void *getBytes, void *putBytes, void *doSeek,
                                                           void *close, int size, void *hdc, int type, void *frameRect,
                                                           int frameUnit, char *description, void *metafile) { return 1; }

GD_PINVOKE_EXPORT int GdipRecordMetafileFromDelegateI_linux(void *getHeader,
                                                            void *getBytes, void *putBytes, void *doSeek,
                                                            void *close, int size, void *hdc, int type, void *frameRect,
                                                            int frameUnit, char *description, void *metafile) { return 1; }

GD_PINVOKE_EXPORT int GdipGetPostScriptGraphicsContext(
    char *filename,
    int width, int height, double dpix, double dpiy, void *graphics) { return 1; }

GD_PINVOKE_EXPORT int GdipGetPostScriptSavePage(void *graphics) { return 1; }

#endif // IPHONE_ENABLED