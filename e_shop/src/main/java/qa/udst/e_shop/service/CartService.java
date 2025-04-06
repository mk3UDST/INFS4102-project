package qa.udst.e_shop.service;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import qa.udst.e_shop.exception.CartException;
import qa.udst.e_shop.exception.ResourceNotFoundException;
import qa.udst.e_shop.model.Cart;
import qa.udst.e_shop.model.CartItem;
import qa.udst.e_shop.model.Product;
import qa.udst.e_shop.model.User;
import qa.udst.e_shop.repository.CartRepository;
import qa.udst.e_shop.repository.ProductRepository;
import qa.udst.e_shop.repository.UserRepository;

@Service
public class CartService {

    @Autowired
    private CartRepository cartRepository;
    
    @Autowired
    private UserRepository userRepository;
    
    @Autowired
    private ProductRepository productRepository;

    public Cart getCartByUserId(Long userId) {
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new ResourceNotFoundException("User not found with id: " + userId));
        
        Cart cart = cartRepository.findByUser(user);
        if (cart == null) {
            cart = new Cart(user);
            cart = cartRepository.save(cart);
        }
        return cart;
    }

    @Transactional
    public Cart addItemToCart(Long userId, Long productId, Integer quantity) {
        if (quantity <= 0) {
            throw new CartException("Quantity must be greater than 0");
        }
        
        Cart cart = getCartByUserId(userId);
        Product product = productRepository.findById(productId)
                .orElseThrow(() -> new ResourceNotFoundException("Product not found with id: " + productId));
        
        // Check if product is in stock
        if (product.getStockQuantity() < quantity) {
            throw new CartException("Not enough stock available. Available: " + product.getStockQuantity());
        }
                
        // Check if product is already in cart
        Optional<CartItem> existingItem = cart.getItems().stream()
                .filter(item -> item.getProduct().getId().equals(productId))
                .findFirst();
        
        if (existingItem.isPresent()) {
            CartItem item = existingItem.get();
            // Check if the new total quantity exceeds available stock
            if (product.getStockQuantity() < (item.getQuantity() + quantity)) {
                throw new CartException("Not enough stock available. Available: " + product.getStockQuantity());
            }
            item.setQuantity(item.getQuantity() + quantity);
        } else {
            CartItem newItem = new CartItem(product, quantity, cart);
            cart.getItems().add(newItem);
        }
        
        cart.setUpdatedAt(LocalDateTime.now());
        return cartRepository.save(cart);
    }

    @Transactional
    public Cart updateCartItemQuantity(Long userId, Long productId, Integer quantity) {
        if (quantity <= 0) {
            return removeItemFromCart(userId, productId);
        }
        
        Cart cart = getCartByUserId(userId);
        Product product = productRepository.findById(productId)
                .orElseThrow(() -> new ResourceNotFoundException("Product not found with id: " + productId));
        
        // Check if product is in stock for the requested quantity
        if (product.getStockQuantity() < quantity) {
            throw new CartException("Not enough stock available. Available: " + product.getStockQuantity());
        }
        
        CartItem item = cart.getItems().stream()
                .filter(i -> i.getProduct().getId().equals(productId))
                .findFirst()
                .orElseThrow(() -> new CartException("Product not found in cart"));
                
        item.setQuantity(quantity);
        cart.setUpdatedAt(LocalDateTime.now());
        return cartRepository.save(cart);
    }

    @Transactional
    public Cart removeItemFromCart(Long userId, Long productId) {
        Cart cart = getCartByUserId(userId);
        
        boolean removed = cart.getItems().removeIf(item -> item.getProduct().getId().equals(productId));
        
        if (!removed) {
            throw new CartException("Product not found in cart");
        }
        
        cart.setUpdatedAt(LocalDateTime.now());
        return cartRepository.save(cart);
    }

    @Transactional
    public void clearCart(Long userId) {
        Cart cart = getCartByUserId(userId);
        cart.getItems().clear();
        cart.setUpdatedAt(LocalDateTime.now());
        cartRepository.save(cart);
    }

    public CartItem getCartItem(Long cartId, Long productId) {
        Cart cart = cartRepository.findById(cartId)
                .orElseThrow(() -> new ResourceNotFoundException("Cart not found with id: " + cartId));
        
        return cart.getItems().stream()
                .filter(item -> item.getProduct().getId().equals(productId))
                .findFirst()
                .orElseThrow(() -> new CartException("Product not found in cart"));
    }

    public Optional<Cart> getCartById(Long cartId) {
        return cartRepository.findById(cartId);
    }

    public BigDecimal calculateCartTotal(Long userId) {
        Cart cart = getCartByUserId(userId);
        
        return cart.getItems().stream()
                .map(item -> item.getProduct().getPrice().multiply(new BigDecimal(item.getQuantity())))
                .reduce(BigDecimal.ZERO, BigDecimal::add);
    }
}
