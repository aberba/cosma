module cosma.css;
import gtk.StyleContext;
import gtk.CssProvider;
import gtk.StyleContext;

class CSS // GTK4 compliant
{
	CssProvider provider;
	string cssPath = "./theme.css";
	StyleContext context;

	this(StyleContext styleContext)
	{
		provider = new CssProvider();
		provider.loadFromPath(cssPath);
		//provider.loadFromData(cssString);
		styleContext.addProvider(provider, GTK_STYLE_PROVIDER_PRIORITY_APPLICATION);
		context = styleContext;
	}

	void addClass(string className)
	{
		context.addClass(className);
	}

} // class CSS
