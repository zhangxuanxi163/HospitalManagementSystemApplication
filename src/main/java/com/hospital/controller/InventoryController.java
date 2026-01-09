package com.hospital.controller;

import com.hospital.entity.Inventory;
import com.hospital.service.InventoryService;
import com.hospital.service.MaterialService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import javax.servlet.http.HttpSession;
import java.util.List;

@Controller
@RequestMapping("/inventory")
public class InventoryController {
    
    @Autowired
    private InventoryService inventoryService;
    
    @Autowired
    private MaterialService materialService;
    
    @GetMapping("/list")
    public String list(Model model, HttpSession session) {
        if (session.getAttribute("user") == null) {
            return "redirect:/login";
        }
        
        List<Inventory> inventories = inventoryService.findAll();
        model.addAttribute("inventories", inventories);
        List<com.hospital.entity.Material> materials = materialService.findAll();
        model.addAttribute("materials", materials);
        java.util.Map<Integer, com.hospital.entity.Material> materialMap = new java.util.HashMap<>();
        for (com.hospital.entity.Material m : materials) {
            materialMap.put(m.getId(), m);
        }
        model.addAttribute("materialMap", materialMap);
        return "inventory/list";
    }
}

