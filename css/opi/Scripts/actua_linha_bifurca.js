importPackage(Packages.org.csstudio.opibuilder.scriptUtil);
importPackage(Packages.org.eclipse.jface.dialogs);
importPackage(Packages.java.lang);

var color;
var colorName;
if(color == ColorFontUtil.GREEN){
	color = ColorFontUtil.RED;
	colorName = "red";
}
else{
	color = ColorFontUtil.GREEN;
	colorName = "Green";
}
display.getWidget("A_Bolinha").setPropertyValue("background_color", color);
widget.setPropertyValue("foreground_color", color);
	
MessageDialog.openInformation(
			null, "Dialog from JavaScript", "JavaScript says: My color is " + colorName + "; and i add 25");
