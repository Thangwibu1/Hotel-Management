package model;

import java.sql.Date;

public class Invoice {
    private int invoiceId;
    private int bookingId;
    private Date issueDate;
    private double price;
    private double discount;
    private double tax;
    private double totalAmount;
    private String status;

    public Invoice() {
    }

    public Invoice(int invoiceId, int bookingId, Date issueDate, double price, double discount, double tax, double totalAmount, String status) {
        this.invoiceId = invoiceId;
        this.bookingId = bookingId;
        this.issueDate = issueDate;
        this.price = price;
        this.discount = discount;
        this.tax = tax;
        this.totalAmount = totalAmount;
        this.status = status;
    }

    public int getInvoiceId() {
        return invoiceId;
    }

    public void setInvoiceId(int invoiceId) {
        this.invoiceId = invoiceId;
    }

    public int getBookingId() {
        return bookingId;
    }

    public void setBookingId(int bookingId) {
        this.bookingId = bookingId;
    }

    public Date getIssueDate() {
        return issueDate;
    }

    public void setIssueDate(Date issueDate) {
        this.issueDate = issueDate;
    }

    public double getPrice() {
        return price;
    }

    public void setPrice(double price) {
        this.price = price;
    }

    public double getDiscount() {
        return discount;
    }

    public void setDiscount(double discount) {
        this.discount = discount;
    }

    public double getTax() {
        return tax;
    }

    public void setTax(double tax) {
        this.tax = tax;
    }

    public double getTotalAmount() {
        return totalAmount;
    }

    public void setTotalAmount(double totalAmount) {
        this.totalAmount = totalAmount;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    @Override
    public String toString() {
        return "Invoice{" +
                "invoiceId=" + invoiceId +
                ", bookingId=" + bookingId +
                ", issueDate=" + issueDate +
                ", price=" + price +
                ", discount=" + discount +
                ", tax=" + tax +
                ", totalAmount=" + totalAmount +
                ", status='" + status + ''' +
                '}';
    }
}
