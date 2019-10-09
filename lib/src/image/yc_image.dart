import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'yc_image_cache_manager.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

const String IMAGE_PLACEHOLDER_LIGHT_SMALL =
    "iVBORw0KGgoAAAANSUhEUgAAAE4AAABOCAIAAAAByLdKAAAACXBIWXMAAAsTAAALEwEAmpwYAAAFIGlUWHRYTUw6Y29tLmFkb2JlLnhtcAAAAAAAPD94cGFja2V0IGJlZ2luPSLvu78iIGlkPSJXNU0wTXBDZWhpSHpyZVN6TlRjemtjOWQiPz4gPHg6eG1wbWV0YSB4bWxuczp4PSJhZG9iZTpuczptZXRhLyIgeDp4bXB0az0iQWRvYmUgWE1QIENvcmUgNS42LWMxNDUgNzkuMTYzNDk5LCAyMDE4LzA4LzEzLTE2OjQwOjIyICAgICAgICAiPiA8cmRmOlJERiB4bWxuczpyZGY9Imh0dHA6Ly93d3cudzMub3JnLzE5OTkvMDIvMjItcmRmLXN5bnRheC1ucyMiPiA8cmRmOkRlc2NyaXB0aW9uIHJkZjphYm91dD0iIiB4bWxuczp4bXA9Imh0dHA6Ly9ucy5hZG9iZS5jb20veGFwLzEuMC8iIHhtbG5zOmRjPSJodHRwOi8vcHVybC5vcmcvZGMvZWxlbWVudHMvMS4xLyIgeG1sbnM6cGhvdG9zaG9wPSJodHRwOi8vbnMuYWRvYmUuY29tL3Bob3Rvc2hvcC8xLjAvIiB4bWxuczp4bXBNTT0iaHR0cDovL25zLmFkb2JlLmNvbS94YXAvMS4wL21tLyIgeG1sbnM6c3RFdnQ9Imh0dHA6Ly9ucy5hZG9iZS5jb20veGFwLzEuMC9zVHlwZS9SZXNvdXJjZUV2ZW50IyIgeG1wOkNyZWF0b3JUb29sPSJBZG9iZSBQaG90b3Nob3AgQ0MgMjAxOSAoTWFjaW50b3NoKSIgeG1wOkNyZWF0ZURhdGU9IjIwMTktMDktMDNUMDk6MzY6MDErMDg6MDAiIHhtcDpNb2RpZnlEYXRlPSIyMDE5LTA5LTE3VDE1OjQyOjIyKzA4OjAwIiB4bXA6TWV0YWRhdGFEYXRlPSIyMDE5LTA5LTE3VDE1OjQyOjIyKzA4OjAwIiBkYzpmb3JtYXQ9ImltYWdlL3BuZyIgcGhvdG9zaG9wOkNvbG9yTW9kZT0iMyIgcGhvdG9zaG9wOklDQ1Byb2ZpbGU9InNSR0IgSUVDNjE5NjYtMi4xIiB4bXBNTTpJbnN0YW5jZUlEPSJ4bXAuaWlkOmYwYmNlYjVmLWMx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";

const String IMAGE_PLACEHOLDER_LIGHT_NORMAL =
    "iVBORw0KGgoAAAANSUhEUgAAAI4AAAA3CAIAAABVWuXiAAAACXBIWXMAAAsTAAALEwEAmpwYAAAFIGlUWHRYTUw6Y29tLmFkb2JlLnhtcAAAAAAAPD94cGFja2V0IGJlZ2luPSLvu78iIGlkPSJXNU0wTXBDZWhpSHpyZVN6TlRjemtjOWQiPz4gPHg6eG1wbWV0YSB4bWxuczp4PSJhZG9iZTpuczptZXRhLyIgeDp4bXB0az0iQWRvYmUgWE1QIENvcmUgNS42LWMxNDUgNzkuMTYzNDk5LCAyMDE4LzA4LzEzLTE2OjQwOjIyICAgICAgICAiPiA8cmRmOlJERiB4bWxuczpyZGY9Imh0dHA6Ly93d3cudzMub3JnLzE5OTkvMDIvMjItcmRmLXN5bnRheC1ucyMiPiA8cmRmOkRlc2NyaXB0aW9uIHJkZjphYm91dD0iIiB4bWxuczp4bXA9Imh0dHA6Ly9ucy5hZG9iZS5jb20veGFwLzEuMC8iIHhtbG5zOmRjPSJodHRwOi8vcHVybC5vcmcvZGMvZWxlbWVudHMvMS4xLyIgeG1sbnM6cGhvdG9zaG9wPSJodHRwOi8vbnMuYWRvYmUuY29tL3Bob3Rvc2hvcC8xLjAvIiB4bWxuczp4bXBNTT0iaHR0cDovL25zLmFkb2JlLmNvbS94YXAvMS4wL21tLyIgeG1sbnM6c3RFdnQ9Imh0dHA6Ly9ucy5hZG9iZS5jb20veGFwLzEuMC9zVHlwZS9SZXNvdXJjZUV2ZW50IyIgeG1wOkNyZWF0b3JUb29sPSJBZG9iZSBQaG90b3Nob3AgQ0MgMjAxOSAoTWFjaW50b3NoKSIgeG1wOkNyZWF0ZURhdGU9IjIwMTktMDktMDNUMDk6MzY6MDErMDg6MDAiIHhtcDpNb2RpZnlEYXRlPSIyMDE5LTA5LTE3VDE1OjQzOjIwKzA4OjAwIiB4bXA6TWV0YWRhdGFEYXRlPSIyMDE5LTA5LTE3VDE1OjQzOjIwKzA4OjAwIiBkYzpmb3JtYXQ9ImltYWdlL3BuZyIgcGhvdG9zaG9wOkNvbG9yTW9kZT0iMyIgcGhvdG9zaG9wOklDQ1Byb2ZpbGU9InNSR0IgSUVDNjE5NjYtMi4xIiB4bXBNTTpJbnN0YW5jZUlEPSJ4bXAuaWlkOjU1ZGZhYzk3LWVm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";

const String IMAGE_PLACEHOLDER_LIGHT_BIG =
    "iVBORw0KGgoAAAANSUhEUgAAAQIAAABiCAIAAAA0rkrpAAAACXBIWXMAAAsTAAALEwEAmpwYAAAFIGlUWHRYTUw6Y29tLmFkb2JlLnhtcAAAAAAAPD94cGFja2V0IGJlZ2luPSLvu78iIGlkPSJXNU0wTXBDZWhpSHpyZVN6TlRjemtjOWQiPz4gPHg6eG1wbWV0YSB4bWxuczp4PSJhZG9iZTpuczptZXRhLyIgeDp4bXB0az0iQWRvYmUgWE1QIENvcmUgNS42LWMxNDUgNzkuMTYzNDk5LCAyMDE4LzA4LzEzLTE2OjQwOjIyICAgICAgICAiPiA8cmRmOlJERiB4bWxuczpyZGY9Imh0dHA6Ly93d3cudzMub3JnLzE5OTkvMDIvMjItcmRmLXN5bnRheC1ucyMiPiA8cmRmOkRlc2NyaXB0aW9uIHJkZjphYm91dD0iIiB4bWxuczp4bXA9Imh0dHA6Ly9ucy5hZG9iZS5jb20veGFwLzEuMC8iIHhtbG5zOmRjPSJodHRwOi8vcHVybC5vcmcvZGMvZWxlbWVudHMvMS4xLyIgeG1sbnM6cGhvdG9zaG9wPSJodHRwOi8vbnMuYWRvYmUuY29tL3Bob3Rvc2hvcC8xLjAvIiB4bWxuczp4bXBNTT0iaHR0cDovL25zLmFkb2JlLmNvbS94YXAvMS4wL21tLyIgeG1sbnM6c3RFdnQ9Imh0dHA6Ly9ucy5hZG9iZS5jb20veGFwLzEuMC9zVHlwZS9SZXNvdXJjZUV2ZW50IyIgeG1wOkNyZWF0b3JUb29sPSJBZG9iZSBQaG90b3Nob3AgQ0MgMjAxOSAoTWFjaW50b3NoKSIgeG1wOkNyZWF0ZURhdGU9IjIwMTktMDktMDNUMDk6MzY6MDErMDg6MDAiIHhtcDpNb2RpZnlEYXRlPSIyMDE5LTA5LTE3VDE1OjQ0OjA2KzA4OjAwIiB4bXA6TWV0YWRhdGFEYXRlPSIyMDE5LTA5LTE3VDE1OjQ0OjA2KzA4OjAwIiBkYzpmb3JtYXQ9ImltYWdlL3BuZyIgcGhvdG9zaG9wOkNvbG9yTW9kZT0iMyIgcGhvdG9zaG9wOklDQ1Byb2ZpbGU9InNSR0IgSUVDNjE5NjYtMi4xIiB4bXBNTTpJbnN0YW5jZUlEPSJ4bXAuaWlkOjE5MGJmODU0LTEw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";

const String IMAGE_PLACEHOLDER_DARK_NORMAL =
    "iVBORw0KGgoAAAANSUhEUgAAAJAAAAA3CAIAAABsPVS5AAAACXBIWXMAAAsTAAALEwEAmpwYAAAFIGlUWHRYTUw6Y29tLmFkb2JlLnhtcAAAAAAAPD94cGFja2V0IGJlZ2luPSLvu78iIGlkPSJXNU0wTXBDZWhpSHpyZVN6TlRjemtjOWQiPz4gPHg6eG1wbWV0YSB4bWxuczp4PSJhZG9iZTpuczptZXRhLyIgeDp4bXB0az0iQWRvYmUgWE1QIENvcmUgNS42LWMxNDUgNzkuMTYzNDk5LCAyMDE4LzA4LzEzLTE2OjQwOjIyICAgICAgICAiPiA8cmRmOlJERiB4bWxuczpyZGY9Imh0dHA6Ly93d3cudzMub3JnLzE5OTkvMDIvMjItcmRmLXN5bnRheC1ucyMiPiA8cmRmOkRlc2NyaXB0aW9uIHJkZjphYm91dD0iIiB4bWxuczp4bXA9Imh0dHA6Ly9ucy5hZG9iZS5jb20veGFwLzEuMC8iIHhtbG5zOmRjPSJodHRwOi8vcHVybC5vcmcvZGMvZWxlbWVudHMvMS4xLyIgeG1sbnM6cGhvdG9zaG9wPSJodHRwOi8vbnMuYWRvYmUuY29tL3Bob3Rvc2hvcC8xLjAvIiB4bWxuczp4bXBNTT0iaHR0cDovL25zLmFkb2JlLmNvbS94YXAvMS4wL21tLyIgeG1sbnM6c3RFdnQ9Imh0dHA6Ly9ucy5hZG9iZS5jb20veGFwLzEuMC9zVHlwZS9SZXNvdXJjZUV2ZW50IyIgeG1wOkNyZWF0b3JUb29sPSJBZG9iZSBQaG90b3Nob3AgQ0MgMjAxOSAoTWFjaW50b3NoKSIgeG1wOkNyZWF0ZURhdGU9IjIwMTktMDktMDNUMDk6MzY6MDErMDg6MDAiIHhtcDpNb2RpZnlEYXRlPSIyMDE5LTA5LTE4VDEwOjExOjM2KzA4OjAwIiB4bXA6TWV0YWRhdGFEYXRlPSIyMDE5LTA5LTE4VDEwOjExOjM2KzA4OjAwIiBkYzpmb3JtYXQ9ImltYWdlL3BuZyIgcGhvdG9zaG9wOkNvbG9yTW9kZT0iMyIgcGhvdG9zaG9wOklDQ1Byb2ZpbGU9InNSR0IgSUVDNjE5NjYtMi4xIiB4bXBNTTpJbnN0YW5jZUlEPSJ4bXAuaWlkOjQ2OTU4NDA4LTE2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";

const String IMAGE_PLACEHOLDER_DARK_BIG =
    "iVBORw0KGgoAAAANSUhEUgAAAQIAAABiCAIAAAA0rkrpAAAACXBIWXMAAAsTAAALEwEAmpwYAAAFIGlUWHRYTUw6Y29tLmFkb2JlLnhtcAAAAAAAPD94cGFja2V0IGJlZ2luPSLvu78iIGlkPSJXNU0wTXBDZWhpSHpyZVN6TlRjemtjOWQiPz4gPHg6eG1wbWV0YSB4bWxuczp4PSJhZG9iZTpuczptZXRhLyIgeDp4bXB0az0iQWRvYmUgWE1QIENvcmUgNS42LWMxNDUgNzkuMTYzNDk5LCAyMDE4LzA4LzEzLTE2OjQwOjIyICAgICAgICAiPiA8cmRmOlJERiB4bWxuczpyZGY9Imh0dHA6Ly93d3cudzMub3JnLzE5OTkvMDIvMjItcmRmLXN5bnRheC1ucyMiPiA8cmRmOkRlc2NyaXB0aW9uIHJkZjphYm91dD0iIiB4bWxuczp4bXA9Imh0dHA6Ly9ucy5hZG9iZS5jb20veGFwLzEuMC8iIHhtbG5zOmRjPSJodHRwOi8vcHVybC5vcmcvZGMvZWxlbWVudHMvMS4xLyIgeG1sbnM6cGhvdG9zaG9wPSJodHRwOi8vbnMuYWRvYmUuY29tL3Bob3Rvc2hvcC8xLjAvIiB4bWxuczp4bXBNTT0iaHR0cDovL25zLmFkb2JlLmNvbS94YXAvMS4wL21tLyIgeG1sbnM6c3RFdnQ9Imh0dHA6Ly9ucy5hZG9iZS5jb20veGFwLzEuMC9zVHlwZS9SZXNvdXJjZUV2ZW50IyIgeG1wOkNyZWF0b3JUb29sPSJBZG9iZSBQaG90b3Nob3AgQ0MgMjAxOSAoTWFjaW50b3NoKSIgeG1wOkNyZWF0ZURhdGU9IjIwMTktMDktMDNUMDk6MzY6MDErMDg6MDAiIHhtcDpNb2RpZnlEYXRlPSIyMDE5LTA5LTE3VDE1OjQ1OjE4KzA4OjAwIiB4bXA6TWV0YWRhdGFEYXRlPSIyMDE5LTA5LTE3VDE1OjQ1OjE4KzA4OjAwIiBkYzpmb3JtYXQ9ImltYWdlL3BuZyIgcGhvdG9zaG9wOkNvbG9yTW9kZT0iMyIgcGhvdG9zaG9wOklDQ1Byb2ZpbGU9InNSR0IgSUVDNjE5NjYtMi4xIiB4bXBNTTpJbnN0YW5jZUlEPSJ4bXAuaWlkOjE2MjY4YzE3LWE4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";

enum PlaceHolderType {
  IMAGE_TYPE_LIGHT_NORMAL, //占位图白色e+易车
  IMAGE_TYPE_LIGHT_SMALL, //占位图白色e
  IMAGE_TYPE_LIGHT_BIG, //大图，占位图白色e+易车
  IMAGE_TYPE_DARK_NORMAL, //占位图黑色e+易车
  IMAGE_TYPE_DARK_SMALL, //小图 占位图黑色e+易车
}

class YCImage extends StatelessWidget {
  final Key key;
  final String imageUrl;
  final ImageWidgetBuilder imageBuilder;
  final double width;
  final double height;
  final bool fadeAnimation;
  final BoxFit fit;
  final PlaceHolderType holderType;

  YCImage({
    this.key,
    @required this.imageUrl,
    this.imageBuilder,
    this.width,
    this.height,
    this.fadeAnimation = false,
    this.fit = BoxFit.cover,
    this.holderType = PlaceHolderType.IMAGE_TYPE_LIGHT_NORMAL,
  });

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      key: key,
      imageUrl: imageUrl,
      width: width,
      height: height,
      imageBuilder: imageBuilder,
      cacheManager: YCImageCacheManager(),
      placeholder: (context, url) => _placeholder(holderType),
      errorWidget: (context, url, obj) => _placeholder(holderType),
      fadeInDuration: fadeAnimation ? Duration(microseconds: 500) : Duration.zero,
      fadeOutDuration: fadeAnimation ? Duration(microseconds: 1000) : Duration.zero,
      fit: fit,
    );
  }

  Widget _placeholder(PlaceHolderType holderType) {
    switch (holderType) {
      case PlaceHolderType.IMAGE_TYPE_LIGHT_NORMAL:
        return Container(
            width: width,
            height: height,
            decoration: BoxDecoration(color: Color.fromARGB(255, 248, 248, 248)),
            child: Center(
              child: Image.memory(
                base64Decode(IMAGE_PLACEHOLDER_LIGHT_NORMAL),
                fit: BoxFit.contain,
                scale: 3,
              ),
            ));
        break;
      case PlaceHolderType.IMAGE_TYPE_LIGHT_SMALL:
        return Container(
            width: width,
            height: height,
            decoration: BoxDecoration(color: Color.fromARGB(255, 248, 248, 248)),
            child: Center(
              child: Image.memory(
                base64Decode(IMAGE_PLACEHOLDER_LIGHT_SMALL),
                fit: BoxFit.contain,
                scale: 3,
              ),
            ));
        break;
      case PlaceHolderType.IMAGE_TYPE_LIGHT_BIG:
        return Container(
            width: width,
            height: height,
            decoration: BoxDecoration(color: Color.fromARGB(255, 248, 248, 248)),
            child: Center(
              child: Image.memory(
                base64Decode(IMAGE_PLACEHOLDER_LIGHT_BIG),
                fit: BoxFit.contain,
                scale: 3,
              ),
            ));
        break;
      case PlaceHolderType.IMAGE_TYPE_DARK_NORMAL:
        return Container(
            width: width,
            height: height,
            decoration: BoxDecoration(color: Color.fromARGB(255, 51, 51, 51)),
            child: new Center(
              child: Image.memory(
                base64Decode(IMAGE_PLACEHOLDER_DARK_BIG),
                fit: BoxFit.contain,
                scale: 3,
              ),
            ));
        break;
      case PlaceHolderType.IMAGE_TYPE_DARK_SMALL:
        return Container(
            width: width,
            height: height,
            decoration: BoxDecoration(color: Color.fromARGB(255, 51, 51, 51)),
            child: new Center(
              child: Image.memory(
                base64Decode(IMAGE_PLACEHOLDER_DARK_NORMAL),
                fit: BoxFit.contain,
                scale: 3,
              ),
            ));
        break;
      default:
        return null;
        break;
    }
  }
}
