/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

/**
 *
 * @author trinhdtu
 */
public class ServiceUsage {

    private int serviceId;
    private String serviceName;
    private int totalUsed;
    private double totalRevenue;

    public ServiceUsage() {
    }

    public ServiceUsage(int serviceId, String serviceName, int totalUsed, double totalRevenue) {
        this.serviceId = serviceId;
        this.serviceName = serviceName;
        this.totalUsed = totalUsed;
        this.totalRevenue = totalRevenue;
    }

    public int getServiceId() {
        return serviceId;
    }

    public void setServiceId(int serviceId) {
        this.serviceId = serviceId;
    }

    public String getServiceName() {
        return serviceName;
    }

    public void setServiceName(String serviceName) {
        this.serviceName = serviceName;
    }

    public int getTotalUsed() {
        return totalUsed;
    }

    public void setTotalUsed(int totalUsed) {
        this.totalUsed = totalUsed;
    }

    public double getTotalRevenue() {
        return totalRevenue;
    }

    public void setTotalRevenue(double totalRevenue) {
        this.totalRevenue = totalRevenue;
    }
    
}
