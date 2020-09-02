importPackage(Packages.org.csstudio.opibuilder.scriptUtil); 
var pv0 = PVUtil.getDouble(pvs[0]);
var pv1 = PVUtil.getDouble(pvs[1]);
if(pv0 == 0)
	widget.setPropertyValue("background_color","Header_Background");
else if(pv0 == 1)
	widget.setPropertyValue("background_color",ColorFontUtil.getColorFromRGB(0,255,0));
if(pv1 == 0)
	widget.setPropertyValue("background_color","Header_Background");
else if(pv1 == 1)
	widget.setPropertyValue("background_color",ColorFontUtil.getColorFromRGB(0,255,0));