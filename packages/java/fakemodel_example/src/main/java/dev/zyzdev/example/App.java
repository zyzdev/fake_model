package dev.zyzdev.example;

import java.util.List;
import java.util.Map;

import dev.zyzdev.FakeModelBuilder;
import dev.zyzdev.annotation.FakeConfig;

public class App {
    public static void main(String[] args) {
        try {
            final FakeModelBuilder fakeModelBuilder = new FakeModelBuilder();

            fakeModelBuilder.addDefultValue("name", "Drew");

            // feed default value to PersonalInfo.secretInfo.
            SecretInfo defSecretInfo = new SecretInfo(27, 163.5, 45, "Jerry");
            fakeModelBuilder.addDefultValue("secretInfo", defSecretInfo);

            // generate fake model of PersonalInfo
            final PersonalInfo personalInfo = fakeModelBuilder.build(PersonalInfo.class);
            System.out.println(personalInfo.toString());
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    class PersonalInfo {

        /// By default, create string value by format
        /// '${Class.name}_${Property.name}_${}'.
        public String name;
        public boolean married;

        /// By default, the value generate randomly which the field type is num and the
        /// range from 0 - 10000.
        /// You can decide range by feed [FakeConfig.minValue] and [FakeConfig.maxValue]
        @FakeConfig(minValue = -100, maxValue = 100)
        public int age;
        public double height;
        public int weight;

        /// Enum
        /// By default, create enum value randomly.
        public Gender gender;

        /// List
        /// By default, the data length of `List` is 1.
        /// You can decide data length by feed [FakeConfig.itemSize]
        @FakeConfig(itemSize = 3)
        public List<String> friends;

        /// Map
        /// By default, the data length of `Map` is 1.
        /// You can decide data length by feed [FakeConfig.itemSize]
        @FakeConfig(itemSize = 2)
        public Map<String, Bank> bankAccounts;

        /// Class
        /// Property type can be class too!
        /// You can feed default value to field or let [fake_model] auto create it.
        public SecretInfo secretInfo;

        @Override
        public String toString() {
            return "PersonalInfo [name=" + name + ", married=" + married + ", age=" + age + ", height=" + height
                    + ", weight=" + weight + ", gender=" + gender + ", friends=" + friends + ", bankAccounts="
                    + bankAccounts + ", secretInfo=" + secretInfo + "]";
        }

    }

    class Bank {
        public int money;

        @Override
        public String toString() {
            return "Bank [money=" + money + "]";
        }

    }

    enum Gender {
        male, female
    }

    static class SecretInfo {
        public SecretInfo(int realAge, double realHeight, int realWeight, String lover) {
            this.realAge = realAge;
            this.realHeight = realHeight;
            this.realWeight = realWeight;
            this.lover = lover;
        }

        public int realAge;
        public double realHeight;
        public int realWeight;
        public String lover;

        @Override
        public String toString() {
            return "SecretInfo [realAge=" + realAge + ", realHeight=" + realHeight + ", realWeight=" + realWeight
                    + ", lover=" + lover + "]";
        }

    }
}
