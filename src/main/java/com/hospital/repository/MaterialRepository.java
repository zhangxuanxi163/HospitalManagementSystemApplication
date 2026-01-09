package com.hospital.repository;

import com.hospital.entity.Material;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;
import java.util.List;

@Repository
public interface MaterialRepository extends JpaRepository<Material, Integer> {
    List<Material> findByMaterialNameContaining(String materialName);
    List<Material> findByMaterialCodeContaining(String materialCode);
    List<Material> findByCategoryId(Integer categoryId);
    
    @Query("SELECT m FROM Material m WHERE m.materialName LIKE %:keyword% OR m.materialCode LIKE %:keyword%")
    List<Material> searchMaterials(@Param("keyword") String keyword);
}

