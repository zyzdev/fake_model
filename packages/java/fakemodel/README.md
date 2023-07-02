## Features

Provide a java library to create fake data model.

* To generate a class model property, you can annotate it with [`FakeConfig`] to config the value generation rule.

## Install

```xml
<dependency>
    <groupId>dev.zyzdev</groupId>
    <artifactId>fakemodel</artifactId>
    <version>0.0.3</version>
</dependency>
```

## Usage

More info see [example].

Assume there has a model class `PersonalInfo`.
To new instance a fake model of `PersonalInfo` by [`FakeModelBuilder`].

```java
import dev.zyzdev.FakeModelBuilder;
import dev.zyzdev.annotation.FakeConfig;

public class App {
    public static void main(String[] args) {
        try {
            final FakeModelBuilder fakeModelBuilder = new FakeModelBuilder();

            // set default value "Jerry" to field "name"
            fakeModelBuilder.addDefultValue("name", "Jerry");

            // generate fake model of PersonalInfo
            final PersonalInfo personalInfo = fakeModelBuilder.build(PersonalInfo.class);
            System.out.println(personalInfo.toString());
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    class PersonalInfo {

        // By default, create string value by format
        // '${Class.name}_${Property.name}_${}'.
        public String name;
        public boolean married;

        // By default, the value generate randomly which the field type is num and the
        // range from 0 - 10000.
        // You can decide range by feed [FakeConfig.minValue] and [FakeConfig.maxValue]
        @FakeConfig(minValue = -100, maxValue = 100)
        public int age;
        public double height;
        public int weight;

        @Override
        public String toString() {
            return "PersonalInfo [name=" + name + ", married=" + married + ", age=" + age + ", height=" + height
                    + ", weight=" + weight + "]";
        }

    }
}
```

## Default property value generation rules

Following table shows the value generation rule for supported types. You can change the rule by annotate property
with [`FakeConfig`].

| Type         | Rule                                                                                              |
|--------------|---------------------------------------------------------------------------------------------------|
| [`boolean`]  | true / false                                                                                      |
| [`Number`]   | random value, 0 - 10000                                                                           |
| [`enum`]     | randomly choose one of the types in the enum                                                      |
| [`String`]   | generate string by format '${class name}\_${property name}\_${generation count of this property}' |
| [`Iterable`] | generate one item only                                                                            |
| [`Map`]      | generate one item only                                                                            |
| [`Array`]    | generate one item only                                                                            |

## Custom property value generation rule

More info see [example].

### @FakeConfig

To design the property generation rule, you can annotate property with [`FakeConfig`].

```java
import dev.zyzdev.annotation.FakeConfig;

class PersonalInfo {

  // By default, create string value by format
  // '${Class.name}_${Property.name}_${}'.
  public String name;
  public boolean married;

  // By default, the value generate randomly which the field type is num and the
  // range from 0 - 10000.
  // You can decide range by feed [FakeConfig.minValue] and [FakeConfig.maxValue]
  @FakeConfig(minValue = -100, maxValue = 100)
  public int age;
  public double height;
  public int weight;

  @Override
  public String toString() {
    return "PersonalInfo [name=" + name + ", married=" + married + ", age=" + age + ", height=" + height
        + ", weight=" + weight + "]";
  }

}
```

[example]: https://github.com/zyzdev/fake_model/tree/main/packages/java/fakemodel_example

[`fakemodel`]: https://central.sonatype.com/artifact/dev.zyzdev/fakemodel/

[`FakeModelBuilder`]: https://javadoc.io/doc/dev.zyzdev/fakemodel/latest/dev/zyzdev/FakeModelBuilder.html

[`FakeConfig`]: https://javadoc.io/doc/dev.zyzdev/fakemodel/latest/dev/zyzdev/annotation/FakeConfig.html

[`boolean`]: https://docs.oracle.com/javase/8/docs/api/java/lang/Boolean.html

[`Number`]: https://docs.oracle.com/javase/8/docs/api/java/lang/Number.html

[`enum`]: https://docs.oracle.com/javase/tutorial/java/javaOO/enum.html

[`String`]: https://api.dart.dev/stable/dart-core/String-class.html

[`Iterable`]: https://docs.oracle.com/javase/8/docs/api/java/lang/Iterable.html

[`Map`]: https://docs.oracle.com/javase/8/docs/api/java/util/Map.html

[`Array`]: https://docs.oracle.com/javase/8/docs/api/java/lang/reflect/Array.html
