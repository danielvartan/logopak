import java.awt.EventQueue;
import java.lang.instrument.Instrumentation;
import java.lang.reflect.Field;
import java.util.List;

/**
 * Java agent that restores Desktop.Action.BROWSE support in Flatpak sandboxes.
 *
 * JDK 17's XDesktopPeer.init() removes BROWSE from supportedActions because
 * GVfs inside the Flatpak sandbox only reports "file" and "resource" URI
 * schemes (no "http"), so the JDK concludes that browser-launching is
 * unsupported.  In reality, gtk_show_uri() works fine via the XDG portal.
 *
 * Fix strategy: wait until the AWT event dispatch thread (EDT) is running,
 * then schedule the fix on it via invokeLater.  All Swing/AWT actions
 * (including user clicks that open a browser) run on the EDT, so by
 * scheduling via invokeLater before any user interaction, the fix is
 * guaranteed to execute first. Running on the EDT also avoids disrupting
 * the normal AWT/X11 initialization sequence, which was the cause of the
 * missing taskbar icon when using a raw background thread.
 */
public class BrowseFix {
    public static void premain(String args, Instrumentation inst) {
        Thread t = new Thread(BrowseFix::waitForEdt, "browse-fix");
        t.setDaemon(true);
        t.start();
    }

    private static void waitForEdt() {
        for (int i = 0; i < 200; i++) {
            try {
                Thread.sleep(50);
            } catch (InterruptedException e) {
                return;
            }
            boolean edtRunning = Thread.getAllStackTraces().keySet().stream()
                    .anyMatch(t -> t.getName().startsWith("AWT-EventQueue"));
            if (edtRunning) {
                EventQueue.invokeLater(BrowseFix::fix);
                return;
            }
        }
    }

    @SuppressWarnings("unchecked")
    private static void fix() {
        try {
            // Trigger XDesktopPeer.initWithLock() if not already done.
            // Running on the EDT keeps AWT initialisation order intact.
            java.awt.Desktop.isDesktopSupported();

            Class<?> xdp = Class.forName("sun.awt.X11.XDesktopPeer");

            Field nativeLibraryLoaded = xdp.getDeclaredField("nativeLibraryLoaded");
            nativeLibraryLoaded.setAccessible(true);
            if (!(boolean) nativeLibraryLoaded.get(null)) {
                return; // GTK did not load; nothing to fix
            }

            Field supportedActions = xdp.getDeclaredField("supportedActions");
            supportedActions.setAccessible(true);
            List<Object> list = (List<Object>) supportedActions.get(null);

            @SuppressWarnings("rawtypes")
            Class<Enum> actionClass = (Class<Enum>) Class.forName("java.awt.Desktop$Action");
            Object browse = Enum.valueOf(actionClass, "BROWSE");

            if (!list.contains(browse)) {
                list.add(browse);
            }
        } catch (Exception e) {
            System.err.println("[BrowseFix] Error: " + e);
        }
    }
}
