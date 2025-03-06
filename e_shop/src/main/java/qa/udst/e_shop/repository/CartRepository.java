package qa.udst.e_shop.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import qa.udst.e_shop.model.Cart;
import qa.udst.e_shop.model.User;

@Repository
public interface CartRepository extends JpaRepository<Cart, Long> {
    Cart findByUser(User user);
    Cart findByUserId(Long userId);
}