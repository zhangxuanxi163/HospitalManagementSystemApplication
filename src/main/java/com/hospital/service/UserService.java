package com.hospital.service;

import com.hospital.entity.User;
import com.hospital.repository.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.util.DigestUtils;
import java.util.List;
import java.util.Optional;

@Service
public class UserService {
    @Autowired
    private UserRepository userRepository;
    
    public List<User> findAll() {
        return userRepository.findAll();
    }
    
    public Optional<User> findById(Integer id) {
        return userRepository.findById(id);
    }
    
    public Optional<User> findByUsername(String username) {
        return userRepository.findByUsername(username);
    }
    
    public User save(User user) {
        if (user.getPassword() != null && !user.getPassword().isEmpty()) {
            // 简单密码加密（实际项目中应使用BCrypt等安全加密方式）
            user.setPassword(DigestUtils.md5DigestAsHex(user.getPassword().getBytes()));
        }
        return userRepository.save(user);
    }
    
    public User update(User user) {
        User existingUser = userRepository.findById(user.getId())
            .orElseThrow(() -> new RuntimeException("用户不存在"));
        
        if (user.getPassword() != null && !user.getPassword().isEmpty()) {
            existingUser.setPassword(DigestUtils.md5DigestAsHex(user.getPassword().getBytes()));
        }
        if (user.getRealName() != null) existingUser.setRealName(user.getRealName());
        if (user.getRole() != null) existingUser.setRole(user.getRole());
        if (user.getDepartment() != null) existingUser.setDepartment(user.getDepartment());
        if (user.getPhone() != null) existingUser.setPhone(user.getPhone());
        if (user.getStatus() != null) existingUser.setStatus(user.getStatus());
        
        return userRepository.save(existingUser);
    }
    
    public void deleteById(Integer id) {
        userRepository.deleteById(id);
    }
    
    public boolean validateLogin(String username, String password) {
        Optional<User> userOpt = userRepository.findByUsername(username);
        if (userOpt.isPresent()) {
            User user = userOpt.get();
            String hashedPassword = DigestUtils.md5DigestAsHex(password.getBytes());
            return hashedPassword.equals(user.getPassword()) && user.getStatus() == 1;
        }
        return false;
    }
}

