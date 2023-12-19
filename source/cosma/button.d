module cosma.button;

import cosma.css;
import gtk.Button : GtkButton = Button;

class Button : GtkButton
{
	this(string btnText)
	{
		super(btnText);

		setName("button");
		new CSS(getStyleContext());
	}
}
