import java.util.Scanner;
import java.util.Random;

public class Main {
    public static void main (String[] args) {
        Scanner scan = new Scanner(System.in);
        int i = scan.nextInt();
        String name = scan.nextLine();

        System.out.println("Hello, " + name + "age:" + i);
    }

}

