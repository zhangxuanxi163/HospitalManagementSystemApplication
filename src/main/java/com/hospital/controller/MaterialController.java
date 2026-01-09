package com.hospital.controller;

import com.hospital.entity.Material;
import com.hospital.service.MaterialService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import javax.servlet.http.HttpSession;
import java.util.List;

@Controller
@RequestMapping("/material")
public class MaterialController {
    
    @Autowired
    private MaterialService materialService;
    
    @GetMapping("/list")
    public String list(@RequestParam(required = false) String keyword, Model model, HttpSession session) {
        if (session.getAttribute("user") == null) {
            return "redirect:/login";
        }
        List<Material> materials;
        if (keyword != null && !keyword.trim().isEmpty()) {
            materials = materialService.search(keyword);
            model.addAttribute("keyword", keyword);
        } else {
            materials = materialService.findAll();
        }
        model.addAttribute("materials", materials);
        return "material/list";
    }
    
    @GetMapping("/add")
    public String addForm(Model model, HttpSession session) {
        if (session.getAttribute("user") == null) {
            return "redirect:/login";
        }
        model.addAttribute("material", new Material());
        return "material/form";
    }
    
    @PostMapping("/save")
    public String save(Material material, RedirectAttributes redirectAttributes) {
        try {
            materialService.save(material);
            redirectAttributes.addFlashAttribute("message", "物资保存成功");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", "保存失败：" + e.getMessage());
        }
        return "redirect:/material/list";
    }
    
    @GetMapping("/edit/{id}")
    public String editForm(@PathVariable Integer id, Model model, HttpSession session) {
        if (session.getAttribute("user") == null) {
            return "redirect:/login";
        }
        Material material = materialService.findById(id)
            .orElseThrow(() -> new RuntimeException("物资不存在"));
        model.addAttribute("material", material);
        return "material/form";
    }
    
    @PostMapping("/update")
    public String update(Material material, RedirectAttributes redirectAttributes) {
        try {
            materialService.update(material);
            redirectAttributes.addFlashAttribute("message", "物资更新成功");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", "更新失败：" + e.getMessage());
        }
        return "redirect:/material/list";
    }
    
    @GetMapping("/delete/{id}")
    public String delete(@PathVariable Integer id, RedirectAttributes redirectAttributes, HttpSession session) {
        Object u = session.getAttribute("user");
        if (u == null) {
            return "redirect:/login";
        }
        if (!(u instanceof com.hospital.entity.User) || !"admin".equals(((com.hospital.entity.User) u).getRole())) {
            redirectAttributes.addFlashAttribute("error", "非管理员用户");
            return "redirect:/material/list";
        }
        try {
            materialService.deleteById(id);
            redirectAttributes.addFlashAttribute("message", "物资删除成功");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", "删除失败：" + e.getMessage());
        }
        return "redirect:/material/list";
    }
}

