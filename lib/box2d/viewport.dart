import 'dart:ui';

import 'package:box2d/box2d.dart';
import 'package:flame/box2d/box2d_component.dart';

class Viewport extends ViewportTransform {
  Size dimensions;

  double scale;

  Viewport(this.dimensions, this.scale)
      : super(new Vector2(dimensions.width / 2, dimensions.height / 2),
            new Vector2(dimensions.width / 2, dimensions.height / 2), scale);

  double worldAlignBottom(double height) =>
      -(dimensions.height / 2 / scale) + height;

  /**
   * Computes the number of horizontal world meters of this viewport considering a
   * percentage of its width.
   *
   * @param percent percetage of the width in [0, 1] range
   */
  double worldWidth(double percent) {
    return percent * (dimensions.width / scale);
  }

  /**
   * Computes the scroll percentage of total screen width of the current viwerport
   * center position.
   *
   * @param screens multiplies the visible screen with to create a bigger virtual
   * screen.
   * @return the percentage in the range of [0, 1]
   */
  double getCenterHorizontalScreenPercentage({double screens: 1.0}) {
    var width = dimensions.width * screens;
//    print("width: $width");
    var x = center.x + ((screens - 1) * dimensions.width / 2);
    double rest = x.abs() % width;
    double scroll = rest / width;
    return x > 0 ? scroll : 1 - scroll;
  }

  /**
   * Follows the spececified body component using a sliding focus window
   * defined as a percentage of the total viewport.
   *
   * @param component to follow.
   * @param horizontal percentage of the horizontal viewport. Null means no horizontal following.
   * @param vertical percentage of the vertical viewport. Null means no vertical following.
   */
  void cameraFollow(BodyComponent component,
      {double horizontal, double vertical}) {
    Vector2 position = component.center;

    double x = center.x;
    double y = center.y;

    if (horizontal != null) {
      Vector2 temp = new Vector2.zero();
      getWorldToScreen(position, temp);

      var margin = horizontal / 2 * dimensions.width / 2;
      var focus = dimensions.width / 2 - temp.x;

      if (focus.abs() > margin) {
        x = dimensions.width / 2 +
            (position.x * scale) +
            (focus > 0 ? margin : -margin);
      }
    }

    if (vertical != null) {
      Vector2 temp = new Vector2.zero();
      getWorldToScreen(position, temp);

      var margin = vertical / 2 * dimensions.height / 2;
      var focus = dimensions.height / 2 - temp.y;

      if (focus.abs() > margin) {
        y = dimensions.height / 2 +
            (position.y * scale) +
            (focus < 0 ? margin : -margin);
      }
    }

    if (x != center.x || y != center.y) {
      setCamera(x, y, scale);
    }
  }

}
