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
            
            // Update product stock
            productService.updateStock(cartItem.getProduct().getId(), cartItem.getQuantity());
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
        
        order.setStatus(status);
        return orderRepository.save(order);
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
