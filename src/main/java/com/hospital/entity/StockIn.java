package com.hospital.entity;

import javax.persistence.*;
import java.time.LocalDateTime;

@Entity
@Table(name = "stock_in")
public class StockIn {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id;
    
    @Column(name = "material_id", nullable = false)
    private Integer materialId;
    
    @Column(nullable = false)
    private Integer quantity;
    
    @Column(name = "operator_id")
    private Integer operatorId;
    
    @Column(name = "supplier_id")
    private Integer supplierId;
    
    @Column(name = "in_date")
    private LocalDateTime inDate;
    
    @Column(name = "batch_no", length = 50)
    private String batchNo;
    
    @Column(columnDefinition = "TEXT")
    private String remark;
    
    @PrePersist
    protected void onCreate() {
        if (inDate == null) {
            inDate = LocalDateTime.now();
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
    
    public Integer getSupplierId() {
        return supplierId;
    }
    
    public void setSupplierId(Integer supplierId) {
        this.supplierId = supplierId;
    }
    
    public LocalDateTime getInDate() {
        return inDate;
    }
    
    public void setInDate(LocalDateTime inDate) {
        this.inDate = inDate;
    }
    
    public String getBatchNo() {
        return batchNo;
    }
    
    public void setBatchNo(String batchNo) {
        this.batchNo = batchNo;
    }
    
    public String getRemark() {
        return remark;
    }
    
    public void setRemark(String remark) {
        this.remark = remark;
    }
}
