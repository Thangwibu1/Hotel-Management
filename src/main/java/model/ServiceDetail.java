package model;

import java.math.BigDecimal;
import java.time.LocalDate;

public class ServiceDetail {

    private int bookingServiceId;  
    private int bookingId;       
    private int serviceId;
    private String serviceName;
    private BigDecimal price;
    private int quantity;
    private LocalDate serviceDate;
    private int status;        

    public ServiceDetail() {
    }

    public ServiceDetail(int bookingServiceId, int bookingId, int serviceId, String serviceName, BigDecimal price, int quantity, LocalDate serviceDate, int status) {
        this.bookingServiceId = bookingServiceId;
        this.bookingId = bookingId;
        this.serviceId = serviceId;
        this.serviceName = serviceName;
        this.price = price;
        this.quantity = quantity;
        this.serviceDate = serviceDate;
        this.status = status;
    }

    
    public ServiceDetail(int serviceId, String serviceName, BigDecimal price, int quantity, LocalDate serviceDate) {
        this.serviceId = serviceId;
        this.serviceName = serviceName;
        this.price = price;
        this.quantity = quantity;
        this.serviceDate = serviceDate;
    }

    public int getBookingServiceId() {
        return bookingServiceId;
    }

    public void setBookingServiceId(int bookingServiceId) {
        this.bookingServiceId = bookingServiceId;
    }

    public int getBookingId() {
        return bookingId;
    }

    public void setBookingId(int bookingId) {
        this.bookingId = bookingId;
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

    public BigDecimal getPrice() {
        return price;
    }

    public void setPrice(BigDecimal price) {
        this.price = price;
    }

    public int getQuantity() {
        return quantity;
    }

    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }

    public LocalDate getServiceDate() {
        return serviceDate;
    }

    public void setServiceDate(LocalDate serviceDate) {
        this.serviceDate = serviceDate;
    }

    public int getStatus() {
        return status;
    }

    public void setStatus(int status) {
        this.status = status;
    }
}
