package com.hospital.controller;

import com.hospital.entity.StockIn;
import com.hospital.entity.StockOut;
import com.hospital.entity.Material;
import com.hospital.entity.User;
import com.hospital.service.MaterialService;
import com.hospital.service.InventoryService;
import com.hospital.repository.StockInRepository;
import com.hospital.repository.StockOutRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import javax.servlet.http.HttpSession;
import java.util.List;

@Controller
@RequestMapping("/stock")
public class StockController {
    
    @Autowired
    private MaterialService materialService;
    
    @Autowired
    private InventoryService inventoryService;
    
    @Autowired
    private StockInRepository stockInRepository;
    
    @Autowired
    private StockOutRepository stockOutRepository;
    
    // ========== 入库管理 ==========
    @GetMapping("/in")
    public String stockInForm(Model model, HttpSession session) {
        if (session.getAttribute("user") == null) {
            return "redirect:/login";
        }
        model.addAttribute("materials", materialService.findAll());
        model.addAttribute("stockIn", new StockIn());
        return "stock/in";
    }
    
    @PostMapping("/in")
    public String stockIn(StockIn stockIn, HttpSession session, RedirectAttributes redirectAttributes) {
        try {
            User user = (User) session.getAttribute("user");
            if (user != null) {
                stockIn.setOperatorId(user.getId());
            }
            
            // 更新库存
            inventoryService.stockIn(stockIn.getMaterialId(), stockIn.getQuantity());
            
            // 保存入库记录
            stockInRepository.save(stockIn);
            
            redirectAttributes.addFlashAttribute("message", "入库成功");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", "入库失败：" + e.getMessage());
        }
        return "redirect:/stock/in/list";
    }
    
    @GetMapping("/in/list")
    public String stockInList(Model model, HttpSession session) {
        if (session.getAttribute("user") == null) {
            return "redirect:/login";
        }
        List<StockIn> stockIns = stockInRepository.findAll();
        model.addAttribute("stockIns", stockIns);
        List<Material> materials = materialService.findAll();
        model.addAttribute("materials", materials);
        java.util.Map<Integer, Material> materialMap = new java.util.HashMap<>();
        for (Material m : materials) {
            materialMap.put(m.getId(), m);
        }
        model.addAttribute("materialMap", materialMap);
        return "stock/in_list";
    }
    
    // ========== 出库管理 ==========
    @GetMapping("/out")
    public String stockOutForm(Model model, HttpSession session) {
        if (session.getAttribute("user") == null) {
            return "redirect:/login";
        }
        model.addAttribute("materials", materialService.findAll());
        model.addAttribute("stockOut", new StockOut());
        return "stock/out";
    }
    
    @PostMapping("/out")
    public String stockOut(StockOut stockOut, HttpSession session, RedirectAttributes redirectAttributes) {
        try {
            User user = (User) session.getAttribute("user");
            if (user != null) {
                stockOut.setOperatorId(user.getId());
            }
            
            // 更新库存
            inventoryService.stockOut(stockOut.getMaterialId(), stockOut.getQuantity());
            
            // 保存出库记录
            stockOutRepository.save(stockOut);
            
            redirectAttributes.addFlashAttribute("message", "出库成功");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", "出库失败：" + e.getMessage());
        }
        return "redirect:/stock/out/list";
    }
    
    @GetMapping("/out/list")
    public String stockOutList(Model model, HttpSession session) {
        if (session.getAttribute("user") == null) {
            return "redirect:/login";
        }
        List<StockOut> stockOuts = stockOutRepository.findAll();
        model.addAttribute("stockOuts", stockOuts);
        List<Material> materials = materialService.findAll();
        model.addAttribute("materials", materials);
        java.util.Map<Integer, Material> materialMap = new java.util.HashMap<>();
        for (Material m : materials) {
            materialMap.put(m.getId(), m);
        }
        model.addAttribute("materialMap", materialMap);
        return "stock/out_list";
    }
}







