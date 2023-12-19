module cosma;

/++
Cosma is a collection of CSS styled compownts built on top of GTK for building GUIs in D. 
+/

public import cosma.css;
public import cosma.button;
public import cosma.column;
public import cosma.labeled_entry;

///
unittest
{
    import gtk.Application : Application;
    import gio.Application : GioApplication = Application;
    import gtk.ApplicationWindow : ApplicationWindow;
    import gtkc.giotypes : GApplicationFlags;
    import gtk.Notebook;

    import cosma : CSS, Column, Button, LabeledEntry;

    class MainWindow : ApplicationWindow
    {
        Notebook notebook;

        this(Application application)
        {
            super(application);

            initUI();
        }

        /**
     * Create and initialize the GTK widgets
     */
        private void initUI()
        {
            this.setSizeRequest(1024, 640);
            //this.setBorderWidth(10);

            // Stack 

            //writeln(fetchAllUsers());
            //writeln(passwordHash("password"));

            // Sign in view
            auto signInView = new Column();
            signInView.setName("card");
            auto viewCSS = new CSS(signInView.getStyleContext());
            viewCSS.addClass("signInView");

            auto emailEntry = new LabeledEntry("Email:");
            auto passwordEntry = new LabeledEntry("Password:");
            passwordEntry.setVisibility(false);
            auto btn = new Button("Sign In");

            signInView.packStart(emailEntry, false, false, 2);
            signInView.packStart(passwordEntry, false, false, 2);
            signInView.packStart(btn, false, false, 2);

            notebook = new Notebook();
            add(notebook);
            notebook.appendPage(signInView, "Sign In");
            notebook.setCurrentPage(signInView);
            notebook.setShowTabs(true);

            showAll();

        }
    }

    int main(string[] args)
    {
        auto application = new Application("cosma.gtkd.com", GApplicationFlags.FLAGS_NONE);
        application.addOnActivate(delegate void(GioApplication app) {
            MainWindow mainWindow = new MainWindow(application);
        });
        return application.run(args);
    }

}
