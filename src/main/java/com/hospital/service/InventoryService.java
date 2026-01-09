package com.hospital.service;

import com.hospital.entity.Inventory;
import com.hospital.repository.InventoryRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import java.util.List;
import java.util.Optional;

@Service
public class InventoryService {
    @Autowired
    private InventoryRepository inventoryRepository;
    
    public List<Inventory> findAll() {
        return inventoryRepository.findAll();
    }
    
    public Optional<Inventory> findByMaterialId(Integer materialId) {
        return inventoryRepository.findByMaterialId(materialId);
    }
    
    public Inventory save(Inventory inventory) {
        return inventoryRepository.save(inventory);
    }
    
    @Transactional
    public Inventory stockIn(Integer materialId, Integer quantity) {
        Optional<Inventory> invOpt = inventoryRepository.findByMaterialId(materialId);
        Inventory inventory;
        if (invOpt.isPresent()) {
            inventory = invOpt.get();
            inventory.setQuantity(inventory.getQuantity() + quantity);
        } else {
            inventory = new Inventory();
            inventory.setMaterialId(materialId);
            inventory.setQuantity(quantity);
        }
        return inventoryRepository.save(inventory);
    }
    
    @Transactional
    public Inventory stockOut(Integer materialId, Integer quantity) {
        Inventory inventory = inventoryRepository.findByMaterialId(materialId)
            .orElseThrow(() -> new RuntimeException("库存记录不存在"));
        
        if (inventory.getQuantity() < quantity) {
            throw new RuntimeException("库存不足");
        }
        
        inventory.setQuantity(inventory.getQuantity() - quantity);
        return inventoryRepository.save(inventory);
    }
    
    public List<Inventory> findLowStock() {
        return inventoryRepository.findAll().stream()
            .filter(inv -> inv.getMinStock() > 0 && inv.getQuantity() <= inv.getMinStock())
            .collect(java.util.stream.Collectors.toList());
    }
}

