// http://tutorials.jenkov.com/java-reflection/fields.html
// http://tutorials.jenkov.com/java-reflection/annotations.html
import java.lang.annotation.Retention;
import java.lang.annotation.RetentionPolicy;
import processing.core.*;

@Retention(RetentionPolicy.RUNTIME)
public @interface Parameter {
float min() default 0;
float max() default 100;
}

/* sample
import java.lang.reflect.Field;
import java.lang.annotation.Annotation;

@Parameter
int valueA = 0;

@Parameter(min = 0.1, max = 0.5)
int valueB = 0;

void setup() {
    for (Field field : getClass().getDeclaredFields()) {
        println("name: " + field.getName() + " type: " + field.getType());
        for (Annotation annotation : field.getAnnotations()) {
            if (annotation instanceof Parameter) {
                Parameter param = (Parameter) annotation;
                println("\tmin: " + param.min());
                println("\tmax: " + param.max());
            }
        }
    }
}
*/