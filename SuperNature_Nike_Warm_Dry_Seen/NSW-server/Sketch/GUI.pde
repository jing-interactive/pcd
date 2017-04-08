// https://docs.oracle.com/javase/6/docs/api/java/lang/reflect/Field.html

import controlP5.*;

ControlP5 cp5;

final String configFile = "data/config.json";
ArrayList<Field> cfgFields = new ArrayList<Field>();

void loadConfig() {
    println("loading config");

    try {
        JSONObject items = loadJSONObject(configFile);
        for (Field field : cfgFields) {
            JSONObject item = items.getJSONObject(field.getName());
            String value = item.getString("value");
            field.set(this, Float.valueOf(value));
        }
    } catch (Exception e) {
        saveConfig();
    }
}

void saveConfig() {
    JSONObject items = new JSONObject();
    int i = 0;
    for (Field field : cfgFields) {
        JSONObject item = new JSONObject();

        try {
            item.setString("value", field.get(this).toString());
        } catch (IllegalAccessException e) {
            println("e: " + e);
        }
        items.setJSONObject(field.getName(), item);
    }

    saveJSONObject(items, configFile);
}

Group grpConfig;
void setupGUI() {
    cp5 = new ControlP5(this);
    cp5.setAutoDraw(false);
    grpConfig = cp5.addGroup("Config");

    for (Field field : getClass().getDeclaredFields()) {
        String fieldName = field.getName();
        if (fieldName.startsWith("CFG_")) {
            println("fieldName: " + fieldName);
            field.setAccessible(true);
            cfgFields.add(field);
        }
    }

    loadConfig();

    for (Field field : cfgFields) {
        String fieldName = field.getName();
        Class<?> type = field.getType();
        if (type.equals(boolean.class)) {
            addToggle(fieldName);
            continue;
        }

        if (field.getAnnotations().length > 0) {
            for (Annotation annotation : field.getAnnotations()) {
                println("name: " + field.getName() + " type: " + field.getType());
                if (annotation instanceof Parameter) {
                    Parameter param = (Parameter) annotation;
                    println("\tmin: " + param.min());
                    println("\tmax: " + param.max());

                    // field.setAccessible(true);
                    // Object value = field.get(this);
                    // float val = ((Float)value).floatValue();
                    addSlider(fieldName, param.min(), param.max());
                }
            }
        } else {
            addSlider(fieldName, 0, 100);
        }
    }

    cp5.addBang("saveConfig")
    // .setWidth(200)
    .setGroup(grpConfig)
    .linebreak()
    ;
}

Toggle addToggle(String name) {
    return cp5.addToggle(name)
           // .setSize(50, 20)
           .setMode(ControlP5.SWITCH)
           .linebreak()
           .setGroup(grpConfig)
           ;
}

Slider addSlider(String name, float minValue, float maxValue) {
    return cp5.addSlider(name)
           .setRange(minValue, maxValue)
           // .setWidth(200)
           .linebreak()
           .setGroup(grpConfig)
           ;
}

controlP5.Button addImageButton(String name, PImage image) {
    return cp5.addButton(name)
           .setImages(image, image, image)
           .updateSize();
}
