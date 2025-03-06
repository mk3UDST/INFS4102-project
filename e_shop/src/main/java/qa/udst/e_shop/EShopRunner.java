package qa.udst.e_shop;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.CommandLineRunner;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

import qa.udst.e_shop.repository.CategoryRepository;
import qa.udst.e_shop.repository.ProductRepository;
import qa.udst.e_shop.repository.UserRepository;
import qa.udst.e_shop.repository.CartRepository;
import qa.udst.e_shop.repository.OrderRepository;

@Component
public class EShopRunner implements CommandLineRunner {

    @Autowired
    private CategoryRepository categoryRepository;
    
    @Autowired
    private ProductRepository productRepository;
    
    @Autowired
    private UserRepository userRepository;
    
    @Autowired
    private CartRepository cartRepository;
    
    @Autowired
    private OrderRepository orderRepository;

    @Override
    @Transactional // Add this annotation to keep the session open
    public void run(String... args) throws Exception {
        System.out.println("\n========== DATABASE VERIFICATION ==========\n");
        
        // Verify categories
        System.out.println("CATEGORIES COUNT: " + categoryRepository.count());
        System.out.println("CATEGORIES: ");
        categoryRepository.findAll().forEach(category -> {
            System.out.println("  - " + category.getId() + ": " + category.getName());
        });
        
        // Verify products
        System.out.println("\nPRODUCTS COUNT: " + productRepository.count());
        System.out.println("PRODUCTS: ");
        productRepository.findAll().forEach(product -> {
            System.out.println("  - " + product.getId() + ": " + product.getName() + 
                    " ($" + product.getPrice() + ") - Category: " + product.getCategory().getName());
        });
        
        // Verify users
        System.out.println("\nUSERS COUNT: " + userRepository.count());
        System.out.println("USERS: ");
        userRepository.findAll().forEach(user -> {
            System.out.println("  - " + user.getId() + ": " + user.getUsername() + 
                    " (" + user.getEmail() + ")");
        });
        
        // Verify carts
        System.out.println("\nCARTS COUNT: " + cartRepository.count());
        System.out.println("CARTS: ");
        cartRepository.findAll().forEach(cart -> {
            System.out.println("  - Cart " + cart.getId() + " for user: " + cart.getUser().getUsername());
            System.out.println("    Items:");
            cart.getItems().forEach(item -> {
                System.out.println("      * " + item.getQuantity() + "x " + 
                        item.getProduct().getName() + " ($" + item.getProduct().getPrice() + ")");
            });
        });
        
        // Verify orders
        System.out.println("\nORDERS COUNT: " + orderRepository.count());
        System.out.println("ORDERS: ");
    }
}