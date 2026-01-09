package com.hospital.controller;

import com.hospital.entity.User;
import com.hospital.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import javax.servlet.http.HttpSession;
import java.util.List;

@Controller
@RequestMapping("/user")
public class UserController {
    
    @Autowired
    private UserService userService;
    
    @GetMapping("/list")
    public String list(Model model, HttpSession session, RedirectAttributes redirectAttributes) {
        Object u = session.getAttribute("user");
        if (u == null) {
            return "redirect:/login";
        }
        if (!(u instanceof User) || !"admin".equals(((User) u).getRole())) {
            redirectAttributes.addFlashAttribute("error", "非管理员用户");
            return "redirect:/";
        }
        List<User> users = userService.findAll();
        model.addAttribute("users", users);
        return "user/list";
    }
    
    @GetMapping("/add")
    public String addForm(Model model, HttpSession session, RedirectAttributes redirectAttributes) {
        Object u = session.getAttribute("user");
        if (u == null) {
            return "redirect:/login";
        }
        if (!(u instanceof User) || !"admin".equals(((User) u).getRole())) {
            redirectAttributes.addFlashAttribute("error", "非管理员用户");
            return "redirect:/";
        }
        model.addAttribute("user", new User());
        return "user/form";
    }
    
    @PostMapping("/save")
    public String save(User user, RedirectAttributes redirectAttributes, HttpSession session) {
        Object u = session.getAttribute("user");
        if (u == null) {
            return "redirect:/login";
        }
        if (!(u instanceof User) || !"admin".equals(((User) u).getRole())) {
            redirectAttributes.addFlashAttribute("error", "非管理员用户");
            return "redirect:/";
        }
        try {
            userService.save(user);
            redirectAttributes.addFlashAttribute("message", "用户保存成功");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", "保存失败：" + e.getMessage());
        }
        return "redirect:/user/list";
    }
    
    @GetMapping("/edit/{id}")
    public String editForm(@PathVariable Integer id, Model model, HttpSession session, RedirectAttributes redirectAttributes) {
        Object u = session.getAttribute("user");
        if (u == null) {
            return "redirect:/login";
        }
        if (!(u instanceof User) || !"admin".equals(((User) u).getRole())) {
            redirectAttributes.addFlashAttribute("error", "非管理员用户");
            return "redirect:/";
        }
        User user = userService.findById(id)
            .orElseThrow(() -> new RuntimeException("用户不存在"));
        model.addAttribute("user", user);
        return "user/form";
    }
    
    @PostMapping("/update")
    public String update(User user, RedirectAttributes redirectAttributes, HttpSession session) {
        Object u = session.getAttribute("user");
        if (u == null) {
            return "redirect:/login";
        }
        if (!(u instanceof User) || !"admin".equals(((User) u).getRole())) {
            redirectAttributes.addFlashAttribute("error", "非管理员用户");
            return "redirect:/";
        }
        try {
            userService.update(user);
            redirectAttributes.addFlashAttribute("message", "用户更新成功");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", "更新失败：" + e.getMessage());
        }
        return "redirect:/user/list";
    }
    
    @GetMapping("/delete/{id}")
    public String delete(@PathVariable Integer id, RedirectAttributes redirectAttributes, HttpSession session) {
        Object u = session.getAttribute("user");
        if (u == null) {
            return "redirect:/login";
        }
        if (!(u instanceof User) || !"admin".equals(((User) u).getRole())) {
            redirectAttributes.addFlashAttribute("error", "非管理员用户");
            return "redirect:/";
        }
        try {
            userService.deleteById(id);
            redirectAttributes.addFlashAttribute("message", "用户删除成功");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", "删除失败：" + e.getMessage());
        }
        return "redirect:/user/list";
    }
}

