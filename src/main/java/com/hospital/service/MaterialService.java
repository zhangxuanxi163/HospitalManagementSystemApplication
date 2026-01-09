package com.hospital.service;

import com.hospital.entity.Material;
import com.hospital.entity.Inventory;
import com.hospital.repository.MaterialRepository;
import com.hospital.repository.InventoryRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import java.util.List;
import java.util.Optional;

@Service
public class MaterialService {
    @Autowired
    private MaterialRepository materialRepository;
    
    @Autowired
    private InventoryRepository inventoryRepository;
    
    public List<Material> findAll() {
        return materialRepository.findAll();
    }
    
    public Optional<Material> findById(Integer id) {
        return materialRepository.findById(id);
    }
    
    public List<Material> search(String keyword) {
        if (keyword == null || keyword.trim().isEmpty()) {
            return findAll();
        }
        return materialRepository.searchMaterials(keyword);
    }
    
    public List<Material> findByCategory(Integer categoryId) {
        return materialRepository.findByCategoryId(categoryId);
    }
    
    @Transactional
    public Material save(Material material) {
        Material saved = materialRepository.save(material);
        // 创建对应的库存记录
        if (!inventoryRepository.existsByMaterialId(saved.getId())) {
            Inventory inventory = new Inventory();
            inventory.setMaterialId(saved.getId());
            inventory.setQuantity(0);
            inventoryRepository.save(inventory);
        }
        return saved;
    }
    
    public Material update(Material material) {
        return materialRepository.save(material);
    }
    
    @Transactional
    public void deleteById(Integer id) {
        inventoryRepository.findByMaterialId(id).ifPresent(inventoryRepository::delete);
        materialRepository.deleteById(id);
    }
}

