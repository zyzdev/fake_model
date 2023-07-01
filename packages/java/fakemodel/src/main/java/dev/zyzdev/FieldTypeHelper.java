package dev.zyzdev;

import java.util.List;
import java.util.Map;
import java.util.Set;

class FieldTypeHelper {

    static boolean isCustomClass(Class<?> type) {
        return !type.isPrimitive() && !isNumber(type) && !isString(type)
                && !type.isArray()
                && !type.isEnum()
                && !type.isInterface();
    }

    static Boolean isBoolean(Class<?> type) {
        return boolean.class.isAssignableFrom(type) || Boolean.class.isAssignableFrom(type);
    }

    static Boolean isString(Class<?> type) {
        return String.class.isAssignableFrom(type);
    }

    static Boolean isNumber(Class<?> type) {
        return type.isPrimitive() || isNumberExtent(type);
    }

    static Boolean isNumberExtent(Class<?> type) {
        return Byte.class.isAssignableFrom(type) || Short.class.isAssignableFrom(type)
                || Integer.class.isAssignableFrom(type) || Long.class.isAssignableFrom(type)
                || Float.class.isAssignableFrom(type) || Double.class.isAssignableFrom(type);
    }

    static Boolean isByte(Class<?> type) {
        return byte.class.isAssignableFrom(type) || Byte.class.isAssignableFrom(type);
    }

    static Boolean isShort(Class<?> type) {
        return short.class.isAssignableFrom(type) || Short.class.isAssignableFrom(type);
    }

    static Boolean isInt(Class<?> type) {
        return int.class.isAssignableFrom(type) || Integer.class.isAssignableFrom(type);
    }

    static Boolean isLong(Class<?> type) {
        return long.class.isAssignableFrom(type) || Long.class.isAssignableFrom(type);
    }

    static Boolean isFloat(Class<?> type) {
        return float.class.isAssignableFrom(type) || Float.class.isAssignableFrom(type);
    }

    static Boolean isDouble(Class<?> type) {
        return double.class.isAssignableFrom(type) || Double.class.isAssignableFrom(type);
    }

    static Boolean isArray(Class<?> type) {
        return type.isArray();
    }

    static Boolean isIterable(Class<?> type) {
        return Iterable.class.isAssignableFrom(type);
    }

    static Boolean isList(Class<?> type) {
        return List.class.isAssignableFrom(type);
    }

    static Boolean isSet(Class<?> type) {
        return Set.class.isAssignableFrom(type);
    }

    static Boolean isMap(Class<?> type) {
        return Map.class.isAssignableFrom(type);
    }

    static Boolean isEnum(Class<?> type) {
        return Enum.class.isAssignableFrom(type);
    }
}