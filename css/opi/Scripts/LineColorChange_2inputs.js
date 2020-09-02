importPackage(Packages.org.csstudio.opibuilder.scriptUtil); 
var pv0 = PVUtil.getDouble(pvs[0]);
var pv1 = PVUtil.getDouble(pvs[1]);
if(pv0 == 0 && pv1 == 0)
	widget.setPropertyValue("background_color","Header_Background");
else if(pv0 == 1 || pv1 ==1)
	widget.setPropertyValue("background_color","MEDM_COLOR_16");