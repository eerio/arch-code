import java.util.Scanner;

public class bitsCounter {
    public static int getBits(int n) {
        int result = 0;
        int div = 2;
        int x;
        for (int i=0; i < 30; ++i) {
            x = (div / 2) * (n / div) + Math.max(0, n % div - (div / 2 - 1));
            result += x;
            // System.out.println("For div=" + div + ": " + x);
            div *= 2;
        }
        return result;
    }

    public static void main(String[] args) {
        Scanner scanner = new Scanner(System.in);
        int i = scanner.nextInt();
        System.out.println(getBits(i));
    }
}

