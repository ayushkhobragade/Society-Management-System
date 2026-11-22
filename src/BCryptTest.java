import org.mindrot.jbcrypt.BCrypt;

public class BCryptTest {
    public static void main(String[] args) {

        String password = "test123";

        // Password ka secure hash banana
        String hashedPassword = BCrypt.hashpw(password, BCrypt.gensalt());

        System.out.println("Original Password: " + password);
        System.out.println("Hashed Password: " + hashedPassword);

        // Password verify karna
        boolean result = BCrypt.checkpw(password, hashedPassword);

        System.out.println("Password Match: " + result);
    }
}