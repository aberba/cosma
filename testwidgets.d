module testwidgets;

import gtk.Box;
import gtk.Label;
import gtk.Entry;
import gtk.Widget;

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
import gtk.Dialog;
import gtk.Window;
import gtk.Button;
import gtk.EditableIF;

import nnipa.utils;

class LabeledEntry : Box
{
	import gtk.Revealer;

	Label label;
	Label error;
	Entry entry;
	Box container;
	Revealer revealer;

	import gio.SimpleAction;
	import glib.Variant;
	import glib.VariantType;

	this(string labelText)
	{
		super(Orientation.VERTICAL, 5);
		setSpacing(10);
		// setName("input_group");
		auto boxCSS = new CSS(getStyleContext());
		boxCSS.addClass("input_group");

		label = new Label(labelText);
		label.setXalign = false;

		error = new Label("");
		error.setXalign = false;
		auto errorCSS = new CSS(error.getStyleContext());
		errorCSS.addClass("error-message");

		revealer = new Revealer();
		revealer.add(error);

		entry = new Entry();
		auto entryCSS = new CSS(entry.getStyleContext());
		entryCSS.addClass("entry");

		//SimpleAction saEntry = new SimpleAction("notify::text", new VariantType("s"), new Variant("left"));
		//   saEntry.addOnActivate(delegate(Variant value, SimpleAction sa) {
		//       //The selected target is passed as the value.
		//       sa.setState(value);
		//   });
		//   addAction(saEntry);

		packStart(label, false, false, 2);
		packStart(entry, false, false, 2);
		packStart(revealer, false, false, 2);
	}

	void setError(string message)
	{
		error.setText(message);

		if (message.length)
		{
			revealer.setRevealChild(true);
		}
		else
		{
			revealer.setRevealChild(false);
		}
	}

	void clearError()
	{
		error.setText("");
		revealer.setRevealChild(false);
	}

	string getText()
	{
		return entry.getText();
	}

	void setText(string message)
	{
		entry.setText(message);
	}

	void setPlaceholderText(string text)
	{
		entry.setPlaceholderText(text);
	}

	void setVisibility(bool isTrue)
	{
		entry.setVisibility(isTrue);
	}

	void onChange(void delegate(EditableIF w) func)
	{
		entry.addOnChanged(func);
	}
}

class Row : Box
{
	this()
	{
		super(Orientation.HORIZONTAL, 5);
	}
}

class Column : Box
{
	this()
	{
		super(Orientation.VERTICAL, 5);
	}
}

class AppButton : Button
{
	this(string btnText)
	{
		super(btnText);

		setName("button");
		auto btnCSS = new CSS(getStyleContext());
	}
}

class Heading : Label
{
	import gtk.StyleContext;

	CSS css;

	this(string text)
	{
		super(text);
		setXalign = false;
		//setName("h1");
		css = new CSS(getStyleContext());
	}

	void addClass(string className)
	{
		import std : toLower, canFind;

		// Only h1-h6 is supported
		string class_ = ["h1", "h2", "h3", "h4", "h5", "h6"].canFind(className)
			? className.toLower : "h1";
		css.addClass(class_);
	}
}

class AppHeaderBar : HeaderBar
{
	Window window;

	this(Window window)
	{
		//HeaderBar
		window = window;

		setShowCloseButton(true);
		setTitle("Nnipa PoS");

		//Normal stateless action
		SimpleAction saNormal = new SimpleAction("normal", null);
		saNormal.addOnActivate(delegate(Variant, SimpleAction) {
			MessageDialog dialog = new MessageDialog(window, DialogFlags.MODAL, MessageType.ERROR, ButtonsType.OK, "Normal action clicked!", null);
			scope (exit)
			{
				dialog.destroy();
			}
			dialog.run();
		});
		// window.addAction(saNormal);

		//Stateful action which generates a Checkbox in popover
		SimpleAction saCheck = new SimpleAction("check", null, new Variant(false));
		saCheck.addOnActivate(delegate(Variant value, SimpleAction sa) {
			bool newState = !sa.getState().getBoolean();
			sa.setState(new Variant(newState));
		});
		// window.addAction(saCheck);

		// Stateful action which uses targets. A target is essentially
		// one of a set of actions that an action can hold as state. When
		// using this type of action there is only one action for it however
		// when creating the menu model there is one menu item for each target.
		//
		// When using this type of action, you need to create the SimpleAction telling
		// it what type of variant the state represents. The parameter "new VariantType("s")" 
		// says that it is a string in this example. See GtkD documentation on VariantType
		// for more information.
		SimpleAction saRadio = new SimpleAction("radio", new VariantType("s"), new Variant("left"));
		saRadio.addOnActivate(delegate(Variant value, SimpleAction sa) {
			//The selected target is passed as the value.
			sa.setState(value);
		});
		// window.addAction(saRadio);

		//Menu Model
		Menu model = new Menu();
		// Note that action names consist of a prefix and an id which when 
		// combined make a detailed name. The prefix comes from the container (ActionMap)
		// that the action is inserted against. GTK Application has a prefix of "app"
		// while GTK ApplicationWindow has a prefix of "win". You can create your own
		// prefixes by creating SimpleActionGroup to hold a set of actions and then call
		// Widget.insertActionGroup with your own prefix. 
		model.append("Normal", "win.normal");
		model.append("Checkbox", "win.check");

		Menu section = new Menu();
		//Note the target of the action is represented by the portion after the double colon
		section.append("Left", "win.radio::left");
		section.append("Center", "win.radio::center");
		section.append("Left", "win.radio::right");
		model.appendSection(null, section);

		// MenuButton
		MenuButton mb = new MenuButton();
		mb.setFocusOnClick(false);
		Image imgHamburger = new Image("open-menu-symbolic", IconSize.MENU);
		mb.add(imgHamburger);

		this.packEnd(mb);

		//Popover
		Popover po = new Popover(mb, model);
		mb.setPopover(po);
	}
}
