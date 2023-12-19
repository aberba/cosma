module cosma.labeled_entry;

// import gdk.Event;

// import gio.Menu;
// import gio.MenuItem;
// import gio.SimpleAction;

// import glib.Variant;
// import glib.VariantType;
import gtk.Box;

class LabeledEntry : Box
{
	import gtk.Revealer;
	import gtk.Label;
	import gtk.Entry;
	import gtk.Widget;
	import gtk.EditableIF;

	import gio.SimpleAction;
	import glib.Variant;
	import glib.VariantType;

	import cosma.css : CSS;

	Label label;
	Label error;
	Entry entry;
	Box container;
	Revealer revealer;

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
