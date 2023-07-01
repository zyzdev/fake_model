package dev.zyzdev;

import java.lang.reflect.Array;
import java.lang.reflect.Constructor;
import java.lang.reflect.Field;
import java.lang.reflect.InvocationTargetException;
import java.lang.reflect.ParameterizedType;
import java.lang.reflect.Type;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;
import java.util.Random;
import java.util.stream.Collectors;

import dev.zyzdev.annotation.FakeConfig;

class FieldGenerator {

    private Random random = new Random();
    private HashMap<String, Integer> strPropertyNameCnt = new HashMap<String, Integer>();
    private HashMap<String, Object> fieldDefValues = new HashMap<String, Object>();
    private HashMap<String, Object> classFieldDefValues = new HashMap<String, Object>();

    public <T> T startGen(Class<T> clazz)
            throws InstantiationException, IllegalAccessException, InvocationTargetException {
        // bind fieldDefValues to clazz
        classFieldDefValues.clear();
        String className = clazz.getSimpleName();
        for (String fieldName : fieldDefValues.keySet()) {
            Object value = fieldDefValues.get(fieldName);
            classFieldDefValues.put(className + "_" + fieldName, value);
        }
        return genClassValue(clazz, "");
    }

    public void addDefultValue(String fieldName, Object value) {
        fieldDefValues.put(fieldName, value);
    }

    public void removeDefultValue(String fieldName) {
        fieldDefValues.remove(fieldName);
    }

    public void removeAllDefultValue(String fieldName) {
        fieldDefValues.clear();
    }

    @SuppressWarnings("unchecked")
    private <T> T genClassValue(Class<T> clazz, String prefix)
            throws InstantiationException, IllegalAccessException, InvocationTargetException {

        Constructor<?> ctor = clazz.getDeclaredConstructors()[0];

        boolean isPrivate = !ctor.isAccessible();
        if (isPrivate)
            ctor.setAccessible(true);

        Object[] initArgs = new Object[ctor.getParameterTypes().length];
        for (int i = 0; i < ctor.getParameterTypes().length; i++) {
            initArgs[i] = null;
        }
        final T fakeModel = (T) ctor.newInstance(initArgs);

        if (isPrivate)
            ctor.setAccessible(false);

        final String className = clazz.getSimpleName();
        final Field[] fds = clazz.getDeclaredFields();

        for (Field field : fds) {
            String fieldName = field.getName();
            Class<?> type = field.getType();
            if (fieldName.equals("this$0"))
                continue;
            Object value = null;
            String defValueKey = className + "_" + fieldName;
            Object defValue = classFieldDefValues.get(defValueKey);
            Type gType = field.getGenericType();
            FakeConfig fakeConfig = null;
            if (field.isAnnotationPresent(FakeConfig.class)) {
                fakeConfig = field.getAnnotation(FakeConfig.class);
            }
            value = genFieldValue(type, new FakeValueConfig(fakeConfig, defValue),
                    prefix.isEmpty() ? className : className + "_" + prefix,
                    fieldName, gType);

            if (value == null)
                continue;
            Boolean canAccess = field.isAccessible();
            if (!canAccess)
                field.setAccessible(true);
            field.set(fakeModel, value);
            if (!canAccess)
                field.setAccessible(false);
        }

        if (isPrivate)
            ctor.setAccessible(false);
        return fakeModel;
    }

    @SuppressWarnings("unchecked")
    private <T> Object genFieldValue(Type type, FakeValueConfig fakeValueConfig, String prefix, String fieldName,
            Type fieldGenericType)
            throws InstantiationException, IllegalAccessException, InvocationTargetException {

        Class<T> clazzType = (Class<T>) type;

        if (fakeValueConfig.defaultValue != null) {
            if (FieldTypeHelper.isNumber(clazzType)) {
                Number numDefValue = (Number) fakeValueConfig.defaultValue;
                return numDefValueHelper(numDefValue, clazzType);
            } else {
                return (T) fakeValueConfig.defaultValue;
            }
        }
        // field can be null, decide value is null or non-null
        if (fakeValueConfig.nullable && random.nextBoolean())
            return null;

        Object value = null;
        if (FieldTypeHelper.isCustomClass(clazzType)) {
            value = genClassValue(clazzType, prefix + "_" + fieldName);
        } else if (FieldTypeHelper.isEnum(clazzType)) {
            Object[] enumMembers = clazzType.getEnumConstants();
            final int size = enumMembers.length;
            final int index = random.nextInt(size);
            value = enumMembers[index];
        } else if (FieldTypeHelper.isBoolean(clazzType)) {
            // Boolean
            value = random.nextBoolean();
        } else if (FieldTypeHelper.isNumber(clazzType)) {
            final double maxValue = fakeValueConfig.maxValue;
            final double minValue = fakeValueConfig.minValue;
            final double baseValue = maxValue - minValue;
            value = random.nextDouble() * baseValue + minValue;
            if (FieldTypeHelper.isInt(clazzType)) {
                value = ((Number) value).intValue();
            } else if (FieldTypeHelper.isLong(clazzType)) {
                value = ((Number) value).longValue();
            } else if (FieldTypeHelper.isFloat(clazzType)) {
                value = ((Number) value).floatValue();
            } else if (FieldTypeHelper.isShort(clazzType)) {
                value = ((Number) value).shortValue();
            } else if (FieldTypeHelper.isByte(clazzType)) {
                value = ((Number) value).byteValue();
            }
        } else if (FieldTypeHelper.isString(clazzType)) {
            // string
            final String key = prefix + "_" + fieldName;
            final int cnt = (strPropertyNameCnt.containsKey(key) ? strPropertyNameCnt.get(key) : 0) + 1;
            value = prefix + "_" + fieldName + "_" + cnt;
            strPropertyNameCnt.put(key, cnt);
        } else if (FieldTypeHelper.isArray(clazzType)) {
            // array
            int itemSize = fakeValueConfig.itemSize;
            Class<?> elementType = clazzType.getComponentType();

            ArrayList<T> values = new ArrayList<>();
            while (values.size() < itemSize) {
                final T element = (T) genFieldValue(elementType, new FakeValueConfig(), prefix, fieldName,
                        null);
                values.add(element);
            }
            // convert to T[]
            if (!FieldTypeHelper.isNumber(elementType) || FieldTypeHelper.isNumberExtent(elementType)) {
                int defSize = values.size();
                T[] array = (T[]) Array.newInstance(elementType, defSize);
                int index = 0;
                for (T element : values) {
                    array[index++] = element;
                }
                value = array;
            } else {
                if (FieldTypeHelper.isByte(elementType)) {
                    value = listToByteArray(values);
                } else if (FieldTypeHelper.isShort(elementType)) {
                    value = listToShortArray(values);
                } else if (FieldTypeHelper.isInt(elementType)) {
                    value = listToIntArray(values);
                } else if (FieldTypeHelper.isLong(elementType)) {
                    value = listToLongArray(values);
                } else if (FieldTypeHelper.isFloat(elementType)) {
                    value = listToFloatArray(values);
                } else if (FieldTypeHelper.isDouble(elementType)) {
                    value = listToDoubleArray(values);
                }
            }
        } else if (FieldTypeHelper.isIterable(clazzType)) {
            // iterable
            int itemSize = fakeValueConfig.itemSize;
            ParameterizedType parameterizedType = (ParameterizedType) fieldGenericType;
            Type[] typeArguments = parameterizedType.getActualTypeArguments();
            Type elementType = typeArguments[0];
            ParameterizedType elementTypeGenericType = null;
            if (elementType instanceof ParameterizedType) {
                elementTypeGenericType = (ParameterizedType) elementType;
                elementType = elementTypeGenericType.getRawType();
            }

            ArrayList<T> values = new ArrayList<>();
            while (values.size() < itemSize) {
                final T element = (T) genFieldValue(elementType, new FakeValueConfig(), prefix, fieldName,
                        elementTypeGenericType);
                values.add(element);
            }

            if (FieldTypeHelper.isSet(clazzType)) {
                value = values.stream().collect(Collectors.toSet());
            } else {
                value = values;
            }
        } else if (FieldTypeHelper.isMap(clazzType)) {
            // map
            int itemSize = fakeValueConfig.itemSize;
            ParameterizedType parameterizedType = (ParameterizedType) fieldGenericType;
            Type[] typeArguments = parameterizedType.getActualTypeArguments();
            Type keyType = typeArguments[0];
            Type valueType = typeArguments[1];
            ParameterizedType keyTypeGenericType = null;
            ParameterizedType valueTypeGenericType = null;
            if (keyType instanceof ParameterizedType) {
                keyTypeGenericType = (ParameterizedType) keyType;
                keyType = keyTypeGenericType.getRawType();
            }
            if (valueType instanceof ParameterizedType) {
                valueTypeGenericType = (ParameterizedType) valueType;
                valueType = valueTypeGenericType.getRawType();
            }

            Map<Object, Object> values = new HashMap<>();
            while (values.size() < itemSize) {
                final Object k = genFieldValue(keyType, new FakeValueConfig(), prefix, fieldName, keyTypeGenericType);
                final Object v = genFieldValue(valueType, new FakeValueConfig(), prefix, fieldName,
                        valueTypeGenericType);
                values.put(k, v);
            }
            value = values;
        }

        return (T) value;
    }

    private Number numDefValueHelper(Number defNumValue, Class<?> clazz) {
        if (FieldTypeHelper.isByte(clazz)) {
            return defNumValue.byteValue();
        } else if (FieldTypeHelper.isShort(clazz)) {
            return defNumValue.shortValue();
        } else if (FieldTypeHelper.isInt(clazz)) {
            return defNumValue.intValue();
        } else if (FieldTypeHelper.isLong(clazz)) {
            return defNumValue.longValue();
        } else if (FieldTypeHelper.isFloat(clazz)) {
            return defNumValue.floatValue();
        } else if (FieldTypeHelper.isDouble(clazz)) {
            return defNumValue.doubleValue();
        } else
            return defNumValue;
    }

    private <T> byte[] listToByteArray(ArrayList<T> from) {
        byte[] array = new byte[from.size()];
        int index = 0;
        for (T element : from) {
            array[index++] = (byte) element;
        }
        return array;
    }

    private <T> short[] listToShortArray(ArrayList<T> from) {
        short[] array = new short[from.size()];
        int index = 0;
        for (T element : from) {
            array[index++] = (short) element;
        }
        return array;
    }

    private <T> int[] listToIntArray(ArrayList<T> from) {
        int[] array = new int[from.size()];
        int index = 0;
        for (T element : from) {
            array[index++] = (int) element;
        }
        return array;
    }

    private <T> long[] listToLongArray(ArrayList<T> from) {
        long[] array = new long[from.size()];
        int index = 0;
        for (T element : from) {
            array[index++] = (long) element;
        }
        return array;
    }

    private <T> float[] listToFloatArray(ArrayList<T> from) {
        float[] array = new float[from.size()];
        int index = 0;
        for (T element : from) {
            array[index++] = (float) element;
        }
        return array;
    }

    private <T> double[] listToDoubleArray(ArrayList<T> from) {
        double[] array = new double[from.size()];
        int index = 0;
        for (T element : from) {
            array[index++] = (double) element;
        }
        return array;
    }

}