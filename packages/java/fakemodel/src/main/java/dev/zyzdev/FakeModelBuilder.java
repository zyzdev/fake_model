package dev.zyzdev;

import java.lang.reflect.InvocationTargetException;

/**
 * This is a library help to new instance of a data model.
 * To custom the generation rule of field value, you should add
 * annotation {@link dev.zyzdev.annotation.FakeConfig} to the field.
 * 
 * @author zyzdev https://github.com/zyzdev
 * @version 0.0.1
 * @since 0.0.1
 */
public class FakeModelBuilder {

    /**
     * A empry argument constructor.
     */
    public FakeModelBuilder() {
    }

    private FieldGenerator fieldGenerator = new FieldGenerator();

    /**
     * Build fake model of T.
     * 
     * @param <T>   the type of data model
     * @param clazz the Class of data model
     * @return the fake data model
     * @throws InstantiationException    new instance data model may exception
     * @throws IllegalAccessException    new instance data model or set value to
     *                                   field may exception.
     * @throws InvocationTargetException new instance data model may exception
     */
    public <T> T build(Class<T> clazz)
            throws InstantiationException, IllegalAccessException, InvocationTargetException {

        return fieldGenerator.startGen(clazz);
    }

    /**
     * Add default value of the field.
     * 
     * @param fieldName the name of the field
     * @param value     the field default value you want to set
     */
    public void addDefultValue(String fieldName, Object value) {
        fieldGenerator.addDefultValue(fieldName, value);
    }

    /**
     * Remove default value of the field.
     * 
     * @param fieldName the name of the field
     */
    public void removeDefultValue(String fieldName) {
        fieldGenerator.removeDefultValue(fieldName);
    }
}
