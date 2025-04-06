package qa.udst.e_shop.service;

import java.math.BigDecimal;
import java.util.List;
import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import qa.udst.e_shop.exception.OrderException;
import qa.udst.e_shop.exception.ResourceNotFoundException;
import qa.udst.e_shop.model.Cart;
import qa.udst.e_shop.model.CartItem;
import qa.udst.e_shop.model.Order;
import qa.udst.e_shop.model.OrderItem;
import qa.udst.e_shop.model.Product;
import qa.udst.e_shop.model.User;
import qa.udst.e_shop.model.Order.OrderStatus;
import qa.udst.e_shop.repository.OrderRepository;
import qa.udst.e_shop.repository.UserRepository;

@Service
public class OrderService {

    @Autowired
    private OrderRepository orderRepository;
    
    @Autowired
    private UserRepository userRepository;
    
    @Autowired
    private CartService cartService;
    
    @Autowired
    private ProductService productService;

    @Transactional
    public Order createOrderFromCart(Long userId) {
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new ResourceNotFoundException("User not found with id: " + userId));
        
        Cart cart = cartService.getCartByUserId(userId);
        
        if (cart.getItems().isEmpty()) {
            throw new OrderException("Cannot create order from empty cart");
        }
        
        // Validate all items in cart have sufficient stock
        for (CartItem cartItem : cart.getItems()) {
            Product product = cartItem.getProduct();
            if (product.getStockQuantity() < cartItem.getQuantity()) {
                throw new OrderException("Not enough stock for product: " + product.getName() + 
                        ". Available: " + product.getStockQuantity() + ", Requested: " + cartItem.getQuantity());
            }
        }
        
        BigDecimal totalAmount = cartService.calculateCartTotal(userId);
        
        Order order = new Order(user, totalAmount);
        order = orderRepository.save(order);
        
        // Convert cart items to order items
        for (CartItem cartItem : cart.getItems()) {
            OrderItem orderItem = new OrderItem(
                order,
                cartItem.getProduct(),
                cartItem.getQuantity(),
                cartItem.getProduct().getPrice()
            );
            order.getItems().add(orderItem);
            
            try {
                // Update product stock
                productService.updateStock(cartItem.getProduct().getId(), cartItem.getQuantity());
            } catch (Exception e) {
                // If stock update fails, throw an exception and rollback the transaction
                throw new OrderException("Failed to update stock for product: " + cartItem.getProduct().getName() + ". " + e.getMessage());
            }
        }
        
        // Save updated order with items
        order = orderRepository.save(order);
        
        // Clear the cart
        cartService.clearCart(userId);
        
        return order;
    }

    public List<Order> getOrdersByUserId(Long userId) {
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new ResourceNotFoundException("User not found with id: " + userId));
        
        return orderRepository.findByUser(user);
    }

    public Optional<Order> getOrderById(Long orderId) {
        return orderRepository.findById(orderId);
    }

    @Transactional
    public Order updateOrderStatus(Long orderId, OrderStatus status) {
        Order order = orderRepository.findById(orderId)
                .orElseThrow(() -> new ResourceNotFoundException("Order not found with id: " + orderId));
        
        // Add additional business logic for status transitions
        if (order.getStatus() == OrderStatus.CANCELED && status != OrderStatus.CANCELED) {
            throw new OrderException("Cannot change status of a canceled order");
        }
        
        // If canceling an order, restore product stock
        if (status == OrderStatus.CANCELED && order.getStatus() != OrderStatus.CANCELED) {
            restoreProductStock(order);
        }
        
        order.setStatus(status);
        return orderRepository.save(order);
    }

    // Add new method to handle restoring stock when order is canceled
    private void restoreProductStock(Order order) {
        for (OrderItem item : order.getItems()) {
            Product product = item.getProduct();
            product.setStockQuantity(product.getStockQuantity() + item.getQuantity());
            productService.createProduct(product);
        }
    }

    public List<Order> getAllOrders() {
        return orderRepository.findAll();
    }

    public List<Order> getOrdersByStatus(OrderStatus status) {
        return orderRepository.findByStatus(status);
    }

    public void deleteOrder(Long orderId) {
        Order order = orderRepository.findById(orderId)
                .orElseThrow(() -> new ResourceNotFoundException("Order not found with id: " + orderId));
        orderRepository.delete(order);
    }
}
