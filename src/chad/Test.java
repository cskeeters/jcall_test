package chad;

public class Test
{
    public void testm() {
        System.out.println("test");
    }
    public static void test() {
        System.out.println("test");
    }

    public void doHi(Hi h) {
        h.hi();
    }

    public void doHi2(Hi2 h) {
        h.hi2();
    }

    public static void main() {
        test();
        Test t = new Test();
        t.testm();

        Friendly f = new Friendly();
        f.hi();
        f.hi2();
        t.doHi(f);
        t.doHi2(f);
    }
}
