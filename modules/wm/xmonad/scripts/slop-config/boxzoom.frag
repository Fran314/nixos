#version 120

uniform sampler2D texture;
uniform sampler2D desktop;
uniform vec2 screenSize;
uniform vec2 mouse;

varying vec2 uvCoord;

bool isInSquare(vec2 pos, vec2 sqCenter, vec2 halfSize)
{
    return distance(pos.x, sqCenter.x) <= halfSize.x && distance(pos.y, sqCenter.y) <= halfSize.y;
}

float squareDistance(vec2 a, vec2 b)
{
    return max(
        distance(a.x, b.x),
        distance(a.y, b.y)
    );
}
float rectDistance(vec2 a, vec2 b, float gradient)
{
    return max(
        distance(a.x, b.x),
        distance(a.y, b.y) * gradient
    );
}

void main()
{
    vec4 GREEN = vec4(0.21, 0.55, 0.23, 1);
    vec4 YELLOW = vec4(1, 0.96, 0.61, 1);
    vec4 WHITE = vec4(1,1,1,1);
    vec4 BLACK = vec4(0,0,0,1);

    vec2 boxSize = vec2(128,128);
    float radius = 128;
    float magstrength = 10;
    float xBoxOffset = -boxSize.x / 2;
    if (mouse.x < boxSize.x) {
        xBoxOffset = -xBoxOffset;
    }
    float yBoxOffset = 64;
    if (mouse.y < boxSize.y) {
        yBoxOffset = -boxSize.y / 2;
    }
    // vec2 boxOffset = vec2(xBoxOffset, yBoxOffset) - boxSize / 2;
    vec2 boxOffset = vec2(0,0);
    vec2 borderSize = vec2(1,1);
    vec4 borderColor = vec4(0,0,0,1);
    vec4 borderColor2 = vec4(0.5,0.5,0,1);
    vec2 squareSize = vec2(10,10);
    vec2 squareBorder = vec2(5,5);

    vec2 worldCoord = uvCoord * screenSize;
    vec2 worldMouse = vec2(mouse.x, screenSize.y - mouse.y);
    // Always offset the lens centre by half a (magnified) pixel to have a central pixel
    vec2 lensCentre = worldMouse + boxOffset;
    vec2 halfMagPixelSize = vec2(magstrength / 2, magstrength / 2);
    vec2 blackBorder1 = halfMagPixelSize + vec2(1,1);
    vec2 whiteBorder = blackBorder1 + vec2(1,1);
    vec2 blackBorder2 = whiteBorder + vec2(1,1);


    vec2 uvBoxOffset = boxOffset/screenSize;
    vec2 uvBoxSize = boxSize/screenSize;
    vec2 uvBorderSize = borderSize/screenSize;
    vec2 uvSquareSize = squareSize/screenSize;
    vec2 uvSquareBorder = squareBorder/screenSize;
    vec2 mpos = vec2(mouse.x, -mouse.y)/screenSize + vec2(0,1);
    vec2 uvLensCenter = mpos + uvBoxOffset + uvBoxSize / 2 + vec2(5, -5) / screenSize;

    float sqDist = squareDistance(uvCoord * screenSize, uvLensCenter * screenSize);
    float rdDist = distance(uvCoord * screenSize, uvLensCenter * screenSize);

    vec4 color;

    // if (isInSquare(uvCoord, uvLensCenter, uvBoxSize / 2 + vec2(1,1) / screenSize)) {
    if (rdDist <= radius + 2) {
        // if (!isInSquare(uvCoord, uvLensCenter, uvBoxSize / 2)) {
        if (rdDist > radius) {
            color = GREEN;
        } else if (
            isInSquare(uvCoord, uvLensCenter, uvSquareSize / 2 + vec2(3,3) / screenSize) &&
            !isInSquare(uvCoord, uvLensCenter, uvSquareSize / 2 + vec2(2,2) / screenSize)
        ) {
            color = BLACK;
        } else if (
            isInSquare(uvCoord, uvLensCenter, uvSquareSize / 2 + vec2(2,2) / screenSize) &&
            !isInSquare(uvCoord, uvLensCenter, uvSquareSize / 2 + vec2(1,1) / screenSize)
        ) {
            color = YELLOW;
        } else if (
            isInSquare(uvCoord, uvLensCenter, uvSquareSize / 2 + vec2(1,1) / screenSize) &&
            !isInSquare(uvCoord, uvLensCenter, uvSquareSize / 2)
        ) {
            color = BLACK;
        } else {
            // Calculate where the UV should be.
            vec2 zoomedUV = ((uvCoord-mpos)-(uvBoxOffset+uvBoxSize/2))/magstrength+mpos;
            // The desktop texture is upside-down due to X11
            vec2 zoomedUVFlipped = vec2( zoomedUV.x, -zoomedUV.y );
            // Then change the color to the desktop color to draw, then add on our rectangle on top.
            vec4 rectColor = texture2D( texture, zoomedUV );
            color = mix( texture2D( desktop, zoomedUVFlipped ), rectColor, rectColor.a );
        }
    } else {
        // float shadowMultiplier = 8 + uvBoxSize.x * screenSize.x / 2 - distance(uvCoord * screenSize, uvLensCenter * screenSize);
        // color = mix(texture2D(desktop, vec2(uvCoord.x, -uvCoord.y)), vec4(0, 0, 0, 1), shadowMultiplier / 10);
        color = texture2D(desktop, vec2(uvCoord.x, -uvCoord.y));
    }

    // if (isInSquare(worldCoord, lensCentre, boxSize / 2 + vec2(1,1))) {
    //     if (!isInSquare(worldCoord, lensCentre, boxSize / 2)) {
    //         color = borderColor2;
    //     } else if(isInSquare(worldCoord, lensCentre, vec2(1,1))) {
    //         color = borderColor2;
    //     } else {
    //         // Calculate where the UV should be.
    //         vec2 zoomedUV = ((uvCoord-mpos)-(uvBoxOffset+uvBoxSize/2))/magstrength+mpos;
    //         // The desktop texture is upside-down due to X11
    //         vec2 zoomedUVFlipped = vec2( zoomedUV.x, -zoomedUV.y );
    //         // Then change the color to the desktop color to draw, then add on our rectangle on top.
    //         vec4 rectColor = texture2D( texture, zoomedUV );
    //         color = mix( texture2D( desktop, zoomedUVFlipped ), rectColor, rectColor.a );
    //     }
    // } else {
    //     color = texture2D(texture, uvCoord);
    // }

    gl_FragColor = color;
}
