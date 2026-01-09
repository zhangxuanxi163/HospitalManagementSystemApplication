package com.hospital.entity;

import javax.persistence.*;
import java.time.LocalDateTime;

@Entity
@Table(name = "stock_out")
public class StockOut {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id;
    
    @Column(name = "material_id", nullable = false)
    private Integer materialId;
    
    @Column(nullable = false)
    private Integer quantity;
    
    @Column(name = "operator_id")
    private Integer operatorId;
    
    @Column(length = 100)
    private String department;
    
    @Column(length = 50)
    private String recipient;
    
    @Column(name = "out_date")
    private LocalDateTime outDate;
    
    @Column(columnDefinition = "TEXT")
    private String purpose;
    
    @Column(columnDefinition = "TEXT")
    private String remark;
    
    @PrePersist
    protected void onCreate() {
        if (outDate == null) {
            outDate = LocalDateTime.now();
        }
    }
    
    // Getters and Setters
    public Integer getId() {
        return id;
    }
    
    public void setId(Integer id) {
        this.id = id;
    }
    
    public Integer getMaterialId() {
        return materialId;
    }
    
    public void setMaterialId(Integer materialId) {
        this.materialId = materialId;
    }
    
    public Integer getQuantity() {
        return quantity;
    }
    
    public void setQuantity(Integer quantity) {
        this.quantity = quantity;
    }
    
    public Integer getOperatorId() {
        return operatorId;
    }
    
    public void setOperatorId(Integer operatorId) {
        this.operatorId = operatorId;
    }
    
    public String getDepartment() {
        return department;
    }
    
    public void setDepartment(String department) {
        this.department = department;
    }
    
    public String getRecipient() {
        return recipient;
    }
    
    public void setRecipient(String recipient) {
        this.recipient = recipient;
    }
    
    public LocalDateTime getOutDate() {
        return outDate;
    }
    
    public void setOutDate(LocalDateTime outDate) {
        this.outDate = outDate;
    }
    
    public String getPurpose() {
        return purpose;
    }
    
    public void setPurpose(String purpose) {
        this.purpose = purpose;
    }
    
    public String getRemark() {
        return remark;
    }
    
    public void setRemark(String remark) {
        this.remark = remark;
    }
}
