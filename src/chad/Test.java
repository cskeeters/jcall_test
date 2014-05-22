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
        h.hi();
        h.hi2();
    }

    public void doI3(I3 i3) {
        i3.m1();
    }

    public void doC(C c) {
        c.m1();
    }

    public static void main(String[] argv) {
        test();
        Test t = new Test();
        t.testm();

        Friendly f = new Friendly();
        f.hi(); // Counts as Friendly2.hi() since type doesn't rull out sub-types.  Mimics eclipse.
        f.hi2();
        Friendly2 f2 = new Friendly2();

        f2.hi();// Eclipse doesn't count for Hi.hi(), but we do and should.
        f2.hi2();

        t.doHi(f2);
        t.doHi2(f2);

        C c = new C();
        t.doI3(c);
    }
}
