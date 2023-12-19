module testapp;

import std.stdio;

import gtk.Application : Application;
import gio.Application : GioApplication = Application;
import gtk.ApplicationWindow : ApplicationWindow;
import gtkc.giotypes : GApplicationFlags;

import gdk.Event;

import gio.Menu;
import gio.MenuItem;
import gio.SimpleAction;

import glib.Variant;
import glib.VariantType;

import gtk.HeaderBar;
import gtk.Image;
import gtk.MenuButton;
import gtk.MessageDialog;
import gtk.Popover;
import gtk.Widget;
import gtk.Dialog;
import gtk.Window;
import gtk.Box;
import gtk.Entry;
import gtk.Button;
import gtk.Notebook;
import gtk.EditableIF;

//import gtk.CenterBox;
// import gtk.ResponseType;

class SignInDialog : Dialog
{
    //string title, Window parent, GtkDialogFlags flags, string[] buttonsText, ResponseType[] responses
    this(ApplicationWindow window)
    {
        super("Sign into your account.", cast(Window) window, GtkDialogFlags.MODAL, [
                "Sign In"
            ], [ResponseType.NONE]);

        //auto btn = new Button("Save");
        //btn.setName("btn");
        //auto btnCSS = new CSS(btn.getStyleContext());
        //btnCSS.addClass("btn_class");

        auto box = new Column();
        auto emailEntry = new LabeledEntry("Email:");
        box.packStart(emailEntry, false, false, 2);

        auto contentArea = getContentArea();
        contentArea.add(box);

    }
}

// Sign up view
class SignUpView : Column
{
    this(void delegate() onSuccess)
    {
        super();

        setName("card");
        auto viewCSS = new CSS(getStyleContext());
        viewCSS.addClass("signUpView");

        auto title = new Heading("Create an account.");
        title.addClass("h1");

        auto businessNameEntry = new LabeledEntry("Business Name:");
        businessNameEntry.setPlaceholderText("e.g. Aduma Enterprise");
        businessNameEntry.onChange(delegate(EditableIF w) {
            businessNameEntry.setError("");
        });

        //entry.addOnChanged((EditableIF _) {
        //    update(entry.getBuffer().getText());
        //});

        auto fnameEntry = new LabeledEntry("First Name:");
        fnameEntry.setPlaceholderText("e.g. Kwaku");
        fnameEntry.onChange(delegate(EditableIF w) { fnameEntry.setError(""); });

        auto lnameEntry = new LabeledEntry("Last Name:");
        lnameEntry.setPlaceholderText("e.g. Obeng");
        lnameEntry.onChange(delegate(EditableIF _) { lnameEntry.setError(""); });

        auto emailEntry = new LabeledEntry("Email:");
        emailEntry.setPlaceholderText("e.g. kwaku@example.com");
        emailEntry.onChange(delegate(EditableIF _) { emailEntry.setError(""); });

        auto passwordEntry = new LabeledEntry("Password:");
        passwordEntry.setVisibility(false);
        passwordEntry.setPlaceholderText(" ******** ");
        passwordEntry.onChange(delegate(EditableIF _) {
            passwordEntry.setError("");
        });

        auto signUpButton = new AppButton("Create Account");

        packStart(title, false, false, 2);
        packStart(businessNameEntry, false, false, 2);
        packStart(fnameEntry, false, false, 2);
        packStart(lnameEntry, false, false, 2);
        packStart(emailEntry, false, false, 2);
        packStart(passwordEntry, false, false, 2);
        packStart(signUpButton, false, false, 2);

        bool doesHaveErrors()
        {
            import std.string : strip;
            import core.time : MonoTime;
            import std.datetime : Clock, UTC, DateTime, SysTime;

            string businessName = businessNameEntry.getText();
            string fname = fnameEntry.getText();
            string lname = lnameEntry.getText();
            string email = emailEntry.getText();
            string password = passwordEntry.getText();
            bool hasErrors = false;

            // writeln(SysTime( DateTime()).toUnixTime());
            // writeln(Clock.currTime(UTC()).toUnixTime);

            if (businessName.strip() == "")
            {
                hasErrors = true;
                businessNameEntry.setError("Please enter your business name.");
            }

            if (fname.strip() == "")
            {
                hasErrors = true;
                fnameEntry.setError("Please enter your first name.");
            }

            if (lname.strip() == "")
            {
                hasErrors = true;
                lnameEntry.setError("Please enter your last name.");
            }

            if (email.strip() == "")
            {
                hasErrors = true;
                emailEntry.setError("Please enter your email address.");
            }

            if (password.strip() == "")
            {
                hasErrors = true;
                passwordEntry.setError("Please enter a password for your account.");
            }

            return hasErrors;
        }

        void handleSignUp(Button btn)
        {
            if (doesHaveErrors())
                return;

            string businessName = businessNameEntry.getText();
            string fname = fnameEntry.getText();
            string lname = lnameEntry.getText();
            string email = emailEntry.getText();
            string password = passwordEntry.getText();

            // create an account
            AccountData data;
            data.businessName = businessName;
            data.fname = fname;
            data.lname = lname;
            data.email = email;
            data.password = password;

            if (UserService.createSystemAccount(data))
                onSuccess();

        }

        signUpButton.addOnClicked(&handleSignUp);
    }
}

class MainWindow : ApplicationWindow
{
    HeaderBar headerBar;
    Column signInView;
    Column mainView;
    SignUpView signUpView;
    Notebook notebook;
    bool isSignedIn = false;

    this(Application application)
    {
        super(application);
        initUI();
        // showAll();
    }

    /**
     * Create and initialize the GTK widgets
     */
    private void initUI()
    {
        this.setSizeRequest(1024, 640);
        //this.setBorderWidth(10);

        // Stack 

        headerBar = new AppHeaderBar(this);

        notebook = new Notebook();
        notebook.setName("mainNotebook");
        // auto notebookCSS = new CSS(notebook.getStyleContext());
        // notebookCSS.addClass("mainNotebbok");
        add(notebook);

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
        auto btn = new AppButton("Sign In");

        signInView.packStart(emailEntry, false, false, 2);
        signInView.packStart(passwordEntry, false, false, 2);
        signInView.packStart(btn, false, false, 2);

        // test view
        mainView = new Column();
        mainView.packStart(new LabeledEntry("Number"), false, false, 2);

        void handleSignUpSuccess()
        {
            notebook.setCurrentPage(mainView);
        }

        signUpView = new SignUpView(&handleSignUpSuccess);

        notebook.appendPage(mainView, "Main");
        notebook.appendPage(signInView, "Sign In");
        notebook.appendPage(signUpView, "Sign Up");
        notebook.setShowTabs(true);

        showAll();

        notebook.setCurrentPage(signUpView);
        if (UserService.hasSystemAccount())
        {
            notebook.setCurrentPage(signInView);
        }

        void handleSignIn(Button btn)
        {
            const email = emailEntry.getText();
            const password = passwordEntry.getText();

            writeln(email, password);
            notebook.setCurrentPage(mainView);
            //initRestOfUI();
            // headerBar.show();
            //setTitlebar(headerBar);
            //showAll();
            // showHeader(headerBar);
        }

        btn.addOnClicked(&handleSignIn);

        //if (!isSignedIn) {
        //    notebook.setCurrentPage(signInView);
        //    return;
        //}
    }

    //void initRestOfUI()
    //{
    //    // 
    //}

    void showHeader(HeaderBar headerBar)
    {
        setTitlebar(headerBar);
        showAll();
    }
}

int main(string[] args)
{
    auto application = new Application("demo.gtkd.Actions", GApplicationFlags.FLAGS_NONE);
    application.addOnActivate(delegate void(GioApplication app) {
        MainWindow mainWindow = new MainWindow(application);
    });
    return application.run(args);
}
