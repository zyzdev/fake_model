package dev.zyzdev.annotation;

import java.lang.annotation.ElementType;
import java.lang.annotation.Retention;
import java.lang.annotation.RetentionPolicy;
import java.lang.annotation.Target;

/**
 * This is an annotation for fakemodel to specify a property generating
 * configuration.
 * 
 * @author zyzdev https://github.com/zyzdev
 * @version 0.0.1
 * @since 0.0.1
 */
@Target(ElementType.FIELD)
@Retention(RetentionPolicy.RUNTIME)
public @interface FakeConfig {

    /**
     * Default setting of nullable.
     */
    static boolean DEFAULT_NULLABLE = false;
    /**
     * Default setting of min value for Number type field.
     */
    static int DEFAULT_MIN_VALUE = 0;
    /**
     * Default setting of max value for Number type field.
     */
    static int DEFAULT_MAX_VALUE = 10000;
    /**
     * Default setting of item size for List or Map type field.
     */
    static int DEFAULT_ITEM_SIZE = 1;

    /**
     * Define field is nullable. By default, non-nullable.
     * 
     * @return field is nullable or non-nullable.
     */
    boolean nullable() default DEFAULT_NULLABLE;

    /**
     * Define min value for Number type field. By default, 0.
     * 
     * @return min value for Number type field.
     */
    double minValue() default DEFAULT_MIN_VALUE;

    /**
     * Define max value for Number type field. By default, 10000.
     * 
     * @return max value for Number type field.
     */
    double maxValue() default DEFAULT_MAX_VALUE;

    /**
     * Define item size for List or Map type field. By default, 1.
     * 
     * @return item size for List or Map type field.
     */
    int itemSize() default DEFAULT_ITEM_SIZE;

}