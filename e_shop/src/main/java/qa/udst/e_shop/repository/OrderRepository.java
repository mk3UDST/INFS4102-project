package qa.udst.e_shop.repository;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import qa.udst.e_shop.model.Order;
import qa.udst.e_shop.model.User;
import qa.udst.e_shop.model.Order.OrderStatus;

@Repository
public interface OrderRepository extends JpaRepository<Order, Long> {
    List<Order> findByUser(User user);
    List<Order> findByUserId(Long userId);
    List<Order> findByStatus(OrderStatus status);
}