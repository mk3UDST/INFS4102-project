package qa.udst.e_shop.controller;

import java.math.BigDecimal;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import qa.udst.e_shop.model.Cart;
import qa.udst.e_shop.service.CartService;

@RestController
@RequestMapping("/api/carts")
public class CartController {

    @Autowired
    private CartService cartService;
    
    // Get cart for a user
    @GetMapping("/user/{userId}")
    public ResponseEntity<Cart> getCartByUserId(@PathVariable Long userId) {
        return ResponseEntity.ok(cartService.getCartByUserId(userId));
    }
    
    // Get cart by ID
    @GetMapping("/{id}")
    public ResponseEntity<Cart> getCartById(@PathVariable Long id) {
        return cartService.getCartById(id)
            .map(ResponseEntity::ok)
            .orElse(ResponseEntity.notFound().build());
    }
    
    // Calculate cart total
    @GetMapping("/user/{userId}/total")
    public ResponseEntity<BigDecimal> calculateCartTotal(@PathVariable Long userId) {
        return ResponseEntity.ok(cartService.calculateCartTotal(userId));
    }
    
    // Add item to cart
    @PostMapping("/user/{userId}/items")
    public ResponseEntity<Cart> addItemToCart(
            @PathVariable Long userId,
            @RequestParam Long productId,
            @RequestParam Integer quantity) {
        return ResponseEntity.ok(cartService.addItemToCart(userId, productId, quantity));
    }
    
    // Update cart item quantity
    @PutMapping("/user/{userId}/items")
    public ResponseEntity<Cart> updateCartItemQuantity(
            @PathVariable Long userId,
            @RequestParam Long productId,
            @RequestParam Integer quantity) {
        return ResponseEntity.ok(cartService.updateCartItemQuantity(userId, productId, quantity));
    }
    
    // Remove item from cart
    @DeleteMapping("/user/{userId}/items/{productId}")
    public ResponseEntity<Cart> removeItemFromCart(
            @PathVariable Long userId,
            @PathVariable Long productId) {
        return ResponseEntity.ok(cartService.removeItemFromCart(userId, productId));
    }
    
    // Clear cart
    @DeleteMapping("/user/{userId}")
    public ResponseEntity<Void> clearCart(@PathVariable Long userId) {
        cartService.clearCart(userId);
        return ResponseEntity.noContent().build();
    }
}