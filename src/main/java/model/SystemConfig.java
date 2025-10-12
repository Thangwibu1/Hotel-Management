package model;

public class SystemConfig {
    private int ConfigId;
    private String ConfigName;
    private int ConfigValue;

    public SystemConfig() {
    }

    public SystemConfig(int configId, String configName, int configValue) {
        ConfigId = configId;
        ConfigName = configName;
        ConfigValue = configValue;
    }

    public int getConfigId() {
        return ConfigId;
    }

    public void setConfigId(int configId) {
        ConfigId = configId;
    }

    public String getConfigName() {
        return ConfigName;
    }

    public void setConfigName(String configName) {
        ConfigName = configName;
    }

    public int getConfigValue() {
        return ConfigValue;
    }

    public void setConfigValue(int configValue) {
        ConfigValue = configValue;
    }

    @Override
    public String toString() {
        return "SystemConfig{" +
                "ConfigId=" + ConfigId +
                ", ConfigName='" + ConfigName + '\'' +
                ", ConfigValue=" + ConfigValue +
                '}';
    }
}
