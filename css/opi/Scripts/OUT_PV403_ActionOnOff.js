importPackage(Packages.org.csstudio.opibuilder.scriptUtil);
var pv = widget.getPVByName("Esther:gas:PV403_OUT");
var value = PVUtil.getLong(pv);
if(value==0)
	pv.setValue(1);
else
	pv.setValue(0);