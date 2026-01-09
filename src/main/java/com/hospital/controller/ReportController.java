package com.hospital.controller;

import com.hospital.entity.Inventory;
import com.hospital.entity.Material;
import com.hospital.service.InventoryService;
import com.hospital.service.MaterialService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import javax.servlet.http.HttpSession;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
@RequestMapping("/report")
public class ReportController {
    
    @Autowired
    private InventoryService inventoryService;
    
    @Autowired
    private MaterialService materialService;
    
    @GetMapping
    public String report(Model model, HttpSession session, org.springframework.web.servlet.mvc.support.RedirectAttributes redirectAttributes) {
        Object u = session.getAttribute("user");
        if (u == null) {
            return "redirect:/login";
        }
        if (!(u instanceof com.hospital.entity.User) || !"admin".equals(((com.hospital.entity.User) u).getRole())) {
            redirectAttributes.addFlashAttribute("error", "非管理员用户");
            return "redirect:/";
        }
        
        // 统计数据
        List<Inventory> inventories = inventoryService.findAll();
        List<Material> materials = materialService.findAll();
        
        // 计算总库存价值
        double totalValue = 0;
        Map<Integer, Material> materialMap = new HashMap<>();
        for (Material m : materials) {
            materialMap.put(m.getId(), m);
        }
        
        for (Inventory inv : inventories) {
            Material material = materialMap.get(inv.getMaterialId());
            if (material != null && material.getPrice() != null) {
                totalValue += material.getPrice().doubleValue() * inv.getQuantity();
            }
        }
        
        // 低库存物资
        List<Inventory> lowStock = inventoryService.findLowStock();
        
        // Top10 数量
        java.util.List<String> topLabels = new java.util.ArrayList<>();
        java.util.List<Integer> topValues = new java.util.ArrayList<>();
        java.util.List<java.util.Map.Entry<Integer, Integer>> qtyList = new java.util.ArrayList<>();
        for (Inventory inv : inventories) {
            qtyList.add(new java.util.AbstractMap.SimpleEntry<>(inv.getMaterialId(), inv.getQuantity()));
        }
        qtyList.sort((a,b) -> Integer.compare(b.getValue(), a.getValue()));
        int limit = Math.min(10, qtyList.size());
        for (int i = 0; i < limit; i++) {
            java.util.Map.Entry<Integer, Integer> e = qtyList.get(i);
            Material m = materialMap.get(e.getKey());
            topLabels.add(m != null ? m.getMaterialName() : ("物资-" + e.getKey()));
            topValues.add(e.getValue());
        }

        // 低库存占比
        int lowCount = lowStock.size();
        int okCount = Math.max(inventories.size() - lowCount, 0);

        model.addAttribute("totalMaterials", materials.size());
        model.addAttribute("totalInventory", inventories.size());
        model.addAttribute("totalValue", totalValue);
        model.addAttribute("lowStockCount", lowStock.size());
        model.addAttribute("lowStock", lowStock);
        model.addAttribute("materials", materials);
        model.addAttribute("inventories", inventories);
        model.addAttribute("materialMap", materialMap);
        model.addAttribute("topLabels", topLabels);
        model.addAttribute("topValues", topValues);
        model.addAttribute("lowCount", lowCount);
        model.addAttribute("okCount", okCount);
        
        return "report/index";
    }
}







