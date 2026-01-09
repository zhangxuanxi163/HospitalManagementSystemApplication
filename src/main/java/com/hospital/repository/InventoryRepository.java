package com.hospital.repository;

import com.hospital.entity.Inventory;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import java.util.Optional;

@Repository
public interface InventoryRepository extends JpaRepository<Inventory, Integer> {
    Optional<Inventory> findByMaterialId(Integer materialId);
    boolean existsByMaterialId(Integer materialId);
}

