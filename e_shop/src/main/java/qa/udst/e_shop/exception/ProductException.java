package qa.udst.e_shop.exception;

import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.ResponseStatus;

@ResponseStatus(HttpStatus.BAD_REQUEST)
public class ProductException extends RuntimeException {
    private static final long serialVersionUID = 1L;

    public ProductException(String message) {
        super(message);
    }

    public ProductException(String message, Throwable cause) {
        super(message, cause);
    }
}