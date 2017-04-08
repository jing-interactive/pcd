boolean overRect2(float x, float y, float width, float height)  {
    return overRect(toX(x), toY(y), toX(width), toY(height));
}

boolean overCircle2(float x, float y, float radius)  {
    return overCircle(toX(x), toY(y), toX(radius));
}

boolean overRect(float x, float y, float width, float height)  {
    if (mouseX >= x && mouseX <= x + width &&
            mouseY >= y && mouseY <= y + height) {
        return true;
    } else {
        return false;
    }
}

boolean overCircle(float x, float y, float radius) {
    float disX = x - mouseX;
    float disY = y - mouseY;
    if (disX * disX + disY * disY < radius * radius) {
        return true;
    } else {
        return false;
    }
}
