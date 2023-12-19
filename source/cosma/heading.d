module cosma.heading;

import gtk.Label;

class Heading : Label
{
	//import gtk.StyleContext;
	import cosma.css;

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
