package qa.udst.e_shop.controller;

import java.math.BigDecimal;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import qa.udst.e_shop.model.Cart;
import qa.udst.e_shop.service.CartService;
import qa.udst.e_shop.exception.CartException;
import qa.udst.e_shop.exception.ResourceNotFoundException;

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
    public ResponseEntity<?> addItemToCart(
            @PathVariable Long userId,
            @RequestParam Long productId,
            @RequestParam Integer quantity) {
        try {
            Cart cart = cartService.addItemToCart(userId, productId, quantity);
            return ResponseEntity.ok(cart);
        } catch (CartException e) {
            return ResponseEntity.badRequest().body(e.getMessage());
        } catch (ResourceNotFoundException e) {
            return ResponseEntity.notFound().build();
        }
    }
    
    // Update cart item quantity
    @PutMapping("/user/{userId}/items")
    public ResponseEntity<?> updateCartItemQuantity(
            @PathVariable Long userId,
            @RequestParam Long productId,
            @RequestParam Integer quantity) {
        try {
            Cart cart = cartService.updateCartItemQuantity(userId, productId, quantity);
            return ResponseEntity.ok(cart);
        } catch (CartException e) {
            return ResponseEntity.badRequest().body(e.getMessage());
        } catch (ResourceNotFoundException e) {
            return ResponseEntity.notFound().build();
        }
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

    // Create a new cart for a user
    @PostMapping("/user/{userId}/new")
    public ResponseEntity<Cart> createNewCart(@PathVariable Long userId) {
        try {
            // First clear any existing cart
            cartService.clearCart(userId);
            
            // Then get a new cart (which will be created if none exists)
            Cart newCart = cartService.getCartByUserId(userId);
            return ResponseEntity.ok(newCart);
        } catch (ResourceNotFoundException e) {
            return ResponseEntity.notFound().build();
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                .body(null);
        }
    }
}