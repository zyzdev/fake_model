package dev.zyzdev;

import dev.zyzdev.annotation.FakeConfig;

class FakeValueConfig {
    final Object defaultValue;
    final Boolean nullable;
    final double minValue;
    final double maxValue;
    final int itemSize;

    public FakeValueConfig() {
        this.defaultValue = null;
        this.nullable = FakeConfig.DEFAULT_NULLABLE;
        this.minValue = FakeConfig.DEFAULT_MIN_VALUE;
        this.maxValue = FakeConfig.DEFAULT_MAX_VALUE;
        this.itemSize = FakeConfig.DEFAULT_ITEM_SIZE;
    }

    public FakeValueConfig(FakeConfig fakeConfig, Object defaultValue) {
        this.defaultValue = defaultValue;
        this.nullable = fakeConfig != null ? fakeConfig.nullable() : FakeConfig.DEFAULT_NULLABLE;
        this.minValue = fakeConfig != null ? fakeConfig.minValue() : FakeConfig.DEFAULT_MIN_VALUE;
        this.maxValue = fakeConfig != null ? fakeConfig.maxValue() : FakeConfig.DEFAULT_MAX_VALUE;
        this.itemSize = fakeConfig != null ? fakeConfig.itemSize() : FakeConfig.DEFAULT_ITEM_SIZE;
    }
}