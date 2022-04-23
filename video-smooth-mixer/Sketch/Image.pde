import java.util.Map;

private HashMap<String, PImage> images = new HashMap<String, PImage>();

// private PImage fetchImage(String name) {
//     println("loading " + name);
//     if (AYSNC_LOAD_IMAGE) {
//         return requestImage(name);
//     } else {
//         return loadImage(name);
//     }
// }

PImage getImage(String filename) {
    PImage img = images.get(filename);
    if (img == null) {
        img = loadImage(filename);
        images.put(filename, img);
    }
    return img;
}

void copyImage(PImage src, PImage dst) {
    dst.copy(src, 0, 0, src.width, src.height, 0, 0, dst.width, dst.height);
    // TODO
    // PApplet.arrayCopy(Nui_GetDepth(), img.pixels);
}

void image(PImage img) {
    if (img.width > 0) {
        image(img, 0, 0, width, height);
    }
}

import java.awt.*;
import java.awt.image.*;
import java.io.*;
import java.util.Iterator;

import javax.imageio.*;
import javax.imageio.stream.*;
import javax.imageio.metadata.*;

void saveJpg(PImage img, String path, int w, int h, float quality) {
    BufferedImage bimg = new BufferedImage(w, h, BufferedImage.TYPE_INT_RGB );
    bimg.setRGB( 0, 0, w, h, img.pixels, 0, img.width);
    Iterator iterator = ImageIO.getImageWritersByFormatName("jpg");
    ImageWriter writer = (ImageWriter)iterator.next();
    ImageWriteParam param = writer.getDefaultWriteParam();
    param.setCompressionMode(ImageWriteParam.MODE_EXPLICIT);
    param.setCompressionQuality(quality);

    File file = new File(path);

    try {
        BufferedOutputStream output =
            new BufferedOutputStream(PApplet.createOutput(file));
        writer.setOutput(ImageIO.createImageOutputStream(output));
        writer.write(null, new IIOImage(bimg, null, null), param);
        writer.dispose();

        output.flush();
        output.close();
        bimg.flush();
    } catch (Exception e) {
        println(e + "@ios");
    }
}
