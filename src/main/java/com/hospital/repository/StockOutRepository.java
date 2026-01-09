package com.hospital.repository;

import com.hospital.entity.StockOut;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface StockOutRepository extends JpaRepository<StockOut, Integer> {
}







