package model;

/**
 * Model cho bảng ROOM_DEVICE
 */
public class RoomDevice {
    private int roomDeviceId;
    private int roomId;
    private int deviceId;
    private int quantity;
    private Integer status;

    // Constructors
    public RoomDevice() {}

    public RoomDevice(int roomId, int deviceId, int quantity) {
        this.roomId = roomId;
        this.deviceId = deviceId;
        this.quantity = quantity;
    }

    public RoomDevice(int roomId, int deviceId, int quantity, Integer status) {
        this.roomId = roomId;
        this.deviceId = deviceId;
        this.quantity = quantity;
        this.status = status;
    }

    public RoomDevice(int roomDeviceId, int roomId, int deviceId, int quantity) {
        this.roomDeviceId = roomDeviceId;
        this.roomId = roomId;
        this.deviceId = deviceId;
        this.quantity = quantity;
    }

    public RoomDevice(int roomDeviceId, int roomId, int deviceId, int quantity, Integer status) {
        this.roomDeviceId = roomDeviceId;
        this.roomId = roomId;
        this.deviceId = deviceId;
        this.quantity = quantity;
        this.status = status;
    }

    // Getters and Setters
    public int getRoomDeviceId() {
        return roomDeviceId;
    }

    public void setRoomDeviceId(int roomDeviceId) {
        this.roomDeviceId = roomDeviceId;
    }

    public int getRoomId() {
        return roomId;
    }

    public void setRoomId(int roomId) {
        this.roomId = roomId;
    }

    public int getDeviceId() {
        return deviceId;
    }

    public void setDeviceId(int deviceId) {
        this.deviceId = deviceId;
    }

    public int getQuantity() {
        return quantity;
    }

    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }

    public Integer getStatus() {
        return status;
    }

    public void setStatus(Integer status) {
        this.status = status;
    }

    @Override
    public String toString() {
        return "RoomDevice{" +
                "roomDeviceId=" + roomDeviceId +
                ", roomId=" + roomId +
                ", deviceId=" + deviceId +
                ", quantity=" + quantity +
                ", status=" + status +
                '}';
    }
}

