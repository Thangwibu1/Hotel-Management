package model;

/**
 * Model cho bảng STAFF
 */
public class Staff {
    private int staffId;
    private String fullName;
    private String role;
    private String username;
    private String passwordHash;
    private String phone;
    private String email;

    // Constructors
    public Staff() {}


    public Staff(String fullName, String role, String username, String passwordHash, String phone, String email) {
        this.fullName = fullName;
        this.role = role;
        this.username = username;
        this.passwordHash = passwordHash;
        this.phone = phone;
        this.email = email;
    }

    public Staff(int staffId, String fullName, String role, String username, String passwordHash, String phone, String email) {
        this.staffId = staffId;
        this.fullName = fullName;
        this.role = role;
        this.username = username;
        this.passwordHash = passwordHash;
        this.phone = phone;
        this.email = email;
    }

    // Getters and Setters
    public int getStaffId() { return staffId; }
    public void setStaffId(int staffId) { this.staffId = staffId; }

    public String getFullName() { return fullName; }
    public void setFullName(String fullName) { this.fullName = fullName; }

    public String getRole() { return role; }
    public void setRole(String role) { this.role = role; }

    public String getUsername() { return username; }
    public void setUsername(String username) { this.username = username; }

    public String getPasswordHash() { return passwordHash; }
    public void setPasswordHash(String passwordHash) { this.passwordHash = passwordHash; }

    public String getPhone() { return phone; }
    public void setPhone(String phone) { this.phone = phone; }

    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }

    @Override
    public String toString() {
        return "Staff{" + "staffId=" + staffId + ", fullName='" + fullName + '\'' + ", role='" + role + '\'' + '}';
    }
}