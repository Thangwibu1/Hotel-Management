package model;

/**
 * Model cho bảng DEVICE
 */
public class Device {
    private int deviceId;
    private String deviceName;
    private String description;

    // Constructors
    public Device() {}

    public Device(String deviceName, String description) {
        this.deviceName = deviceName;
        this.description = description;
    }

    public Device(int deviceId, String deviceName, String description) {
        this.deviceId = deviceId;
        this.deviceName = deviceName;
        this.description = description;
    }

    // Getters and Setters
    public int getDeviceId() {
        return deviceId;
    }

    public void setDeviceId(int deviceId) {
        this.deviceId = deviceId;
    }

    public String getDeviceName() {
        return deviceName;
    }

    public void setDeviceName(String deviceName) {
        this.deviceName = deviceName;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    @Override
    public String toString() {
        return "Device{" +
                "deviceId=" + deviceId +
                ", deviceName='" + deviceName + '\'' +
                ", description='" + description + '\'' +
                '}';
    }
}

